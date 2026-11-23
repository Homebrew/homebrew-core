class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://github.com/elastic/logstash/archive/refs/tags/v9.5.7.tar.gz"
  sha256 "fc052c9b5c2482770adfc1817c64f5811f6ce05ecccac5b8f2edf6d854163bc3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "6e0dcd447d1ffa30e3d4fbac51accb367d0779de9332d1c1b761741d6fc754c5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09162aa085f0d699c657e51c156e18daa79e0b0e3aa2af9abbfbd4e42838bc95"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "390f999835fdf2c6537cd9850762d9b015f0154583b8fbf6915b50c4cc53ad26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a34a97c4c7ec6600d01e3704fce2edc4f178661364ec71b7ab87b5f745f34121"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0d0b250651778e89596fd9a021bc984cf7f05959a451e9d5303e652fc9789d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2b48bdb14eddbfabb4eb88df7a2d7db53a1a0dad2aa73e809444a42c4bfb5a51"
  end

  depends_on "gradle@8" => :build # gradle 9 support issue, https://github.com/elastic/logstash/issues/16641
  depends_on "openjdk@21"

  uses_from_macos "ruby" => :build

  def install
    # remove non open source files
    rm_r("x-pack")
    # remove x-pack reference from build.gradle
    inreplace "build.gradle",
              'apply from: "${projectDir}/x-pack/distributions/internal/observabilitySRE/build-ext.gradle"',
              ""
    ENV["OSS"] = "true"
    # Unset superenv's forced `ruby` platform: logstash-core is java-only, so JRuby's Bundler cannot resolve it
    ENV.delete "BUNDLE_FORCE_RUBY_PLATFORM"

    # Ensure Logstash core jars are built for the no-JDK artifact.
    system "gradle", "bootstrap"

    # Build the package from source
    system "rake", "artifact:no_bundle_jdk_tar"
    # Extract the package to the current directory
    mkdir "tar"
    system "tar", "--strip-components=1", "-xf", Dir["build/logstash-*.tar.gz"].first, "-C", "tar"
    cd "tar"

    inreplace "bin/logstash",
              %r{^\. "\$\(cd `dirname \$\{SOURCEPATH\}`/\.\.; pwd\)/bin/logstash\.lib\.sh"},
              ". #{libexec}/bin/logstash.lib.sh"
    inreplace "bin/logstash-plugin",
              %r{^\. "\$\(cd `dirname \$0`/\.\.; pwd\)/bin/logstash\.lib\.sh"},
              ". #{libexec}/bin/logstash.lib.sh"
    inreplace "bin/logstash.lib.sh",
              /^LOGSTASH_HOME=.*$/,
              "LOGSTASH_HOME=#{libexec}"

    # Delete Windows and other Arch/OS files
    paths_to_keep = OS.linux? ? "#{Hardware::CPU.arch}-#{OS.kernel_name}" : OS.kernel_name
    rm Dir["bin/*.bat"]
    Dir["vendor/jruby/tmp/lib/jni/*"].each do |path|
      rm_r path unless path.include? paths_to_keep
    end

    libexec.install Dir["*"]

    # Move config files into etc
    pkgetc.install Dir[libexec/"config/*"]
    rm_r(libexec/"config")
    libexec.install_symlink pkgetc => "config"

    bin.install libexec/"bin/logstash", libexec/"bin/logstash-plugin"
    bin.env_script_all_files libexec/"bin", LS_JAVA_HOME: "${LS_JAVA_HOME:-#{Language::Java.java_home("21")}}"

    # remove non-native architecture pre-built libraries
    paths = [
      libexec/"vendor/jruby/lib/ruby/stdlib/libfixposix/binary",
    ]
    paths.each do |path|
      path.each_child { |dir| rm_r(dir) unless dir.to_s.include? Hardware::CPU.arch.to_s }
    end
    rm_r libexec/"vendor/jruby/lib/ruby/stdlib/libfixposix/binary/arm64-darwin" if OS.mac? && Hardware::CPU.arm?
  end

  def caveats
    "Configuration files are located in #{pkgetc}/"
  end

  service do
    run opt_bin/"logstash"
    keep_alive false
    working_dir var
    log_path var/"log/logstash.log"
    error_log_path var/"log/logstash.log"
  end

  test do
    # workaround https://github.com/elastic/logstash/issues/6378
    (testpath/"config").mkpath
    ["jvm.options", "log4j2.properties", "startup.options"].each do |f|
      cp prefix/"libexec/config/#{f}", testpath/"config"
    end
    (testpath/"config/logstash.yml").write <<~YAML
      path.queue: #{testpath}/queue
    YAML
    (testpath/"data").mkpath
    (testpath/"logs").mkpath
    (testpath/"queue").mkpath

    data = "--path.data=#{testpath}/data"
    logs = "--path.logs=#{testpath}/logs"
    settings = "--path.settings=#{testpath}/config"

    output = pipe_output("#{bin}/logstash -e '' #{data} #{logs} #{settings} --log.level=fatal", "hello world\n")
    assert_match "hello world", output
  end
end

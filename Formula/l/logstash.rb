class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://github.com/elastic/logstash/archive/refs/tags/v9.3.0.tar.gz"
  sha256 "8dc7d3623f14ae59c5d62219c1ec45a3057cfb5c7ec76aa15fdafed98841abec"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2f15e2397fcb897af92fa710c730dff0b919ca170f3947e58f43e3e99ddea26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37c825c47cf2b892b8829e5560a25f40449d5b5698c586bc0bae712c9ba430a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c662780683a1bfcbdb0351868a7df627d17fdeddaad40b5a00a62eee2d12a40"
    sha256 cellar: :any,                 sonoma:        "958151f7e6b08c4cff84bea292460df3ef84e4e4d316b97aa696b66064106721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c80c787340cd1d1536569396b2f6e11de978a07bdfc4e239042a707bb9b62747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d4a59674458287e61434a058070e00fc0cad8473c2abccf83a506922955afd8"
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

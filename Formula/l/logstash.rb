class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://github.com/elastic/logstash/archive/refs/tags/v9.2.4.tar.gz"
  sha256 "caa9bc31f2388456c731d1108c09c9bebf37526f82b71d1873a30754a42b3801"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "980e225f06860772ef46e69313151a6d2bb6baff03c8fff4374b7721735ef411"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a07dbfa86b19e6aeb315f9a4a387c2741336150b2f155336eb1c3cf2a0e421f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03d6559744363f03b4b3ed0fd3f12b221608e85ed70a0807f561f74d1e622f3d"
    sha256 cellar: :any,                 sonoma:        "3e6c4d6724f4e96c315d33a2dd11284baa8ae9496637c1c0a955533178fef9b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd9778b5677ded7c8c101fdbe316a27d6e7f1551debbbafab6bc2f1ef387417f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0859b5e34aa064bb74247672fda4f686db1abf241faf31bf1934b46418d5b350"
  end

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

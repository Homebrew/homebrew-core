class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://github.com/elastic/logstash/archive/v8.5.2.tar.gz"
  sha256 "24c1aafc95e701a13eb5d6f3134811ac24b914457dddd3023890486413f4ebdc"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "39f137bbfcdd3064fb008a95317a9feac3f7b55a83b05e4b49842ab1db43e0bb"
    sha256 cellar: :any,                 arm64_monterey: "189ead43b22fd5d311b3b22c249d44fd8ac0d6b83c73cff2ebaa22a19c7f410f"
    sha256 cellar: :any,                 arm64_big_sur:  "a7b3002d3780e04fd2b1216e3c8833867a7105cee646aa04435e25cc0ffc2367"
    sha256 cellar: :any,                 ventura:        "c568c93bdac280c86729e9f218df2dfbb9054d4412c364af3c0134143300a823"
    sha256 cellar: :any,                 monterey:       "26a9f2d5dfcc42354c13ddee5f734ddbcb07632c7d7711f39c85b549c8f222ae"
    sha256 cellar: :any,                 big_sur:        "b4630ead28a8ef27252b66f18ca18f0a74113fcc66ac3e18cba0f0867a41ee26"
    sha256 cellar: :any,                 catalina:       "c638f83ca9f6a6aa8f0451c41889050dc1190cb1012b5038b23095f90ab4021e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d822bd27c6c688c51ca9dca3abc002f93fe7c68343661feb4c53eb5a5183831"
  end

  depends_on "openjdk@17"

  uses_from_macos "ruby" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"
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
    Dir["vendor/jruby/lib/jni/*"].each do |path|
      rm_r path unless path.include? paths_to_keep
    end

    libexec.install Dir["*"]

    # Move config files into etc
    (etc/"logstash").install Dir[libexec/"config/*"]
    (libexec/"config").rmtree

    bin.install libexec/"bin/logstash", libexec/"bin/logstash-plugin"
    bin.env_script_all_files libexec/"bin", LS_JAVA_HOME: "${LS_JAVA_HOME:-#{Language::Java.java_home("17")}}"
  end

  def post_install
    ln_s etc/"logstash", libexec/"config"
  end

  def caveats
    <<~EOS
      Configuration files are located in #{etc}/logstash/
    EOS
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
    (testpath/"config/logstash.yml").write <<~EOS
      path.queue: #{testpath}/queue
    EOS
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

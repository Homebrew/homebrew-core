class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://github.com/elastic/logstash/archive/v7.14.2.tar.gz"
  sha256 "094b9e1a1c6031a092d3f9d0cc7bbf2b74302b3ba6912135381f0e4265606fe7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "02db87c4194fd1ff3f2dd864b7c1deb3350a0c9e434b4f182845e752f8e18c03"
    sha256 cellar: :any,                 catalina:     "fb2eb9a36fa80a35a86023a72b7b5c0ab858dacdcf129f9e7bd5a9c4ef3a7a27"
    sha256 cellar: :any,                 mojave:       "d9bea1dee925648a819e44978734bd5f07370c23c0522c8f3db30673c197350b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a64777902a09a37493fc30100786f00dce1191e77a2bb0f4c465b8a2bc2d2c49"
  end

  depends_on "openjdk@11"

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
    rm Dir["bin/*.bat"]
    os = if OS.mac?
      "Darwin"
    else
      "x86_64-Linux"
    end
    Dir["vendor/jruby/lib/jni/*"].each do |path|
      rm_r path unless path.include? os
    end

    libexec.install Dir["*"]

    # Move config files into etc
    (etc/"logstash").install Dir[libexec/"config/*"]
    (libexec/"config").rmtree

    bin.install libexec/"bin/logstash", libexec/"bin/logstash-plugin"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("11")
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

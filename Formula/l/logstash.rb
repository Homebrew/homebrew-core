class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://github.com/elastic/logstash/archive/v8.9.2.tar.gz"
  sha256 "d68695777f7edc7579bff361c15159a7a6c324d7927de9ebad853968c640ea36"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cc51456e9ca9eddd95d5fb232792f85707affecb5f8cf02d8af285188d369f47"
    sha256 cellar: :any,                 arm64_ventura:  "e34817d1f68d7effe0b0f7310034193a3a5611a37892179d6d204ed88c3aa5e2"
    sha256 cellar: :any,                 arm64_monterey: "d2d3333d5f2a8d6e6153f628710a2c1ef38bcb6d201c7f2de6fdef73a6ba79c8"
    sha256 cellar: :any,                 arm64_big_sur:  "caf12aba29b1f6d7967f6cd90c09744b1a38eb9c3021c36cf25d6fdc1a7ed112"
    sha256 cellar: :any,                 sonoma:         "637a5588a9f5667ce859f4d22472764a7fe90f81af8d002437da70228f88d905"
    sha256 cellar: :any,                 ventura:        "d5eeb1ce4f2e0d2bb9534372356271d5e639a33cafe6b3ca8004d87cb51de71a"
    sha256 cellar: :any,                 monterey:       "b146b258b177789dd72f1bfb2b79a47adbf9be2c04db1f2c5272d785daf44903"
    sha256 cellar: :any,                 big_sur:        "1585a56f5ebf9448ee9b87856426330ccaebd6ec90bbaa6f59d21b9fb71f18c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d096d4ffd71d1d27963e1558348e2664e8fbd633a0e63c08b7ac26f3bf68cd2"
  end

  depends_on "openjdk@17"

  uses_from_macos "ruby" => :build

  # Ruby 3.2 compatibility.
  # https://github.com/elastic/logstash/pull/14838
  patch do
    on_linux do
      url "https://github.com/elastic/logstash/commit/95870c0f7a7c008c10e848191f85a1065e7db800.patch?full_index=1"
      sha256 "b09065efe41a0098266d1243df19c6e35f4d075db06b41309c8fa791b25453f5"
    end
  end

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
    Dir["vendor/jruby/tmp/lib/jni/*"].each do |path|
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

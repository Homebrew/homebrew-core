class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://github.com/elastic/logstash/archive/v8.6.1.tar.gz"
  sha256 "cde9743f311bfafe2b816e9c4d6bb5c12dbfde07545ecf0b641e1ae47facc888"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1cfedbd506877a19f10fb8b61e106bc69e6b23f9118c8b8382bcfe8f5f5eec61"
    sha256 cellar: :any,                 arm64_monterey: "7cd5824518bbbcc86fb48d1464faa65b234df33f05c97c5425bd93d9191ed9d7"
    sha256 cellar: :any,                 arm64_big_sur:  "5884c4bfc8c7fc705d1805d7464a94a4ed9345b8eafdd6cc7bbf8267f54cc534"
    sha256 cellar: :any,                 ventura:        "676f3a933e53d26425693547fce45ef935cb470e90d7d45d3e61f2a956e4f265"
    sha256 cellar: :any,                 monterey:       "be7960fbc343b439cee138943a5cee47d8f5172844c8bc3ae0d967603901c96c"
    sha256 cellar: :any,                 big_sur:        "fb10797f071a004a684edf4c3030609211a45199f160b9d283d720933277f8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10be251cc931dbcc1368de32e653207a0d4086c7d7f39c592c0fb7a03f148a8c"
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

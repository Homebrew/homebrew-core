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
    sha256 cellar: :any,                 arm64_ventura:  "23e36c401a126fe391ccc4a18affd3611aeeaa59bd3be41c95b4cd111781c702"
    sha256 cellar: :any,                 arm64_monterey: "506de52410a47a28b7f27b060a9e07ab73324f7ba5de30e8b1a77fb9f36ac08b"
    sha256 cellar: :any,                 arm64_big_sur:  "c1aed8f4a8d6ed95103b207fe5a17935978f1e1aa526895a28e3dd5ed7785ccf"
    sha256 cellar: :any,                 ventura:        "704ca343c318cf669c7f45f3c9fb4ffa7717c735f68d2a27b0e24607accb9d50"
    sha256 cellar: :any,                 monterey:       "05fbaae8c40529fe02c0ffd591a4fe74679e9d580cf528f08b6209ed770df357"
    sha256 cellar: :any,                 big_sur:        "9e5288a241358349c40e5817acb0df7591d9d9442538bcef926a7cdc94531d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac9ecb57f27b1a7299d67d3ba0ae2f0fdc4d755de29d6557c7a59d3cafd2b36f"
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

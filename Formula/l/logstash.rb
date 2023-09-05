class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://github.com/elastic/logstash/archive/v8.9.1.tar.gz"
  sha256 "8e5e9d07b64cc9a94c9470de9fd74a20a8bd4af7dd9175a4f421e09b07beb08e"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a97110c5340a12024b4098822b4fcc0ba49a1dafd008b344b2ca067c8e12d945"
    sha256 cellar: :any,                 arm64_monterey: "3719e1fe606eb36ac63de7e20a5105cc37df1e1c568e4d1f6f57d8a8d7aa7bf2"
    sha256 cellar: :any,                 arm64_big_sur:  "d2c7f731a9c40fbee7465ffe1e131fb44dfa9055b1494f712e15ed232350a12d"
    sha256 cellar: :any,                 ventura:        "fc24249e8be0a847233f60f3dab3042bad53bedc2b5335d41eea851c99f63a03"
    sha256 cellar: :any,                 monterey:       "1a6b4410d8b461e4e707b357aba12199c4723b2c57206f515c441231701f05f3"
    sha256 cellar: :any,                 big_sur:        "df09ae2e037b8bfb6ab5277259c31b2e88ea9148265d19eaac7170ac381967ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0b1db9bd6e1068352de301f208fdd4eb0069d352fbd5317c0111e3bc9d3278"
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

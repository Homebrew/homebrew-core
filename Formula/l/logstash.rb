class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://github.com/elastic/logstash/archive/refs/tags/v9.4.4.tar.gz"
  sha256 "ec31af9e3dcc5a3cc5f4ff2677016b1d499cebc0c3b868ff8123eae56045b3cf"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69f5c6fbfc9e1d14bdd1cab404b7dca9836da02dde99388c38583c8fe8d900f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c86767f805e26dd6210a23d5d1821c55041333401466f87d0c341842d723e91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d54970889e932279e11256c28b601bbc79416d7cca88afb09708da1878e04d"
    sha256 cellar: :any,                 sonoma:        "2882cd7a92529264f2f547fcd232187c284fc10d727e30de1ce5c14ab9f1d9d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a293e49b8e93b4b3bfc4a372a3ed5261d8bfddad50fa7d541fe725f68e3d8220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bef694bf33a18024e628e255928a691ec7fe6e2d8ce7730e5f9cfae639ffd25a"
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

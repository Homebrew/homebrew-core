class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.8.6",
      revision: "fa471b2f70b2f54afa594fa23f170f3bb6435c6a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "720bd31764fe52b13d33727474aeae8f136f39dafd7b2be3ca9a4ba718fbd884"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f941098d23ac4e09831cc6307de3612db0f68c98b1299420ca578aa9429f01d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1a19b526779bd5765316dd2bb421d51f8089cfa5047ff9e49df23ec8845a4b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "679edda4a31c922485d3dd3365740318440a7b64b0bc5485674a93c57ac7eac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3e195a47608eff28e3d4845590073f46945c2c6fa066a7b861bb4d6952d2ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26902c74d9cdf96d37051cc3872edc8d7b4cbd7e6c80e2073dea616146bd97d1"
  end

  depends_on "gradle" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

  on_linux do
    on_arm do
      depends_on "python-setuptools" => :build
    end
  end

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/wrapper/gradle-wrapper.properties", "gradle-9.3.1", "gradle-#{Formula["gradle"].version}"

    # Use yarn and node from Homebrew
    inreplace "gradle/node/yarn-projects.gradle", "download = true", "download = false"
    inreplace "gradle/libs.versions.toml" do |s|
      s.gsub! "node = \"18.18.2\"", "node = \"#{Formula["node@22"].version}\""
      s.gsub! "yarn = \"1.22.19\"", "yarn = \"#{Formula["yarn"].version}\""
    end

    system "gradle", "assemble", "--no-daemon"

    cd "distribution/build/dist" do
      inreplace "dcs/conf/logging/appender-file.xml", "${dcs:home}/logs", var/"log/carrot2"
      libexec.install Dir["*"]
    end

    (bin/"carrot2").write_env_script "#{libexec}/dcs/dcs",
      JAVA_CMD:    "exec '#{Formula["openjdk"].opt_bin}/java'",
      SCRIPT_HOME: libexec/"dcs"
  end

  service do
    run opt_bin/"carrot2"
    working_dir opt_libexec
  end

  test do
    port = free_port
    pid = spawn bin/"carrot2", "--port", port.to_s
    sleep 20
    assert_match "Lingo", shell_output("curl -s localhost:#{port}/service/list")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

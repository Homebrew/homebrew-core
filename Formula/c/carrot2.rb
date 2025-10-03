class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.8.2",
      revision: "7095f6f97895668ad6bcc6bcf5689ed748c9945e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13e9707b629eec3787dfaa7c9523ce632b60cb9abc5347fdf917c745dda76b46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ecb572491b0ee47cd972ea4df41d1323133149981226421bcd5f26df665053a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c68f294a28703d3838d65f8323f6fc7be13d6373b14b0a536793d2352d18b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a6498f81a05d2e2c81813678118358bd1a298b56213edeed63da73e13303a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26d3471987d904d9deae77dbf15c18713cb78667cb943feb1c96ec3393f3c45c"
  end

  depends_on "gradle" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build
  depends_on "openjdk@21"

  on_linux do
    on_arm do
      depends_on "python-setuptools" => :build
    end
  end

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/wrapper/gradle-wrapper.properties", "gradle-8.14", "gradle-#{Formula["gradle"].version}"

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
      JAVA_CMD:    "exec '#{Formula["openjdk@21"].opt_bin}/java'",
      SCRIPT_HOME: libexec/"dcs"
  end

  service do
    run opt_bin/"carrot2"
    working_dir opt_libexec
  end

  test do
    port = free_port
    fork { exec bin/"carrot2", "--port", port.to_s }
    sleep 20
    assert_match "Lingo", shell_output("curl -s localhost:#{port}/service/list")
  end
end

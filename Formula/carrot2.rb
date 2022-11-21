class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.5.0",
      revision: "cc33e2022a473ecb0a3c6f28b5ce19ad496f13b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69de3f82e3f515bbae8b9f324516cff276e44fb59414f6d85cf9b8ca7f164f31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58c34ba802ae45ae5405161254d3f7cb31dc5cc47877f1f05ab48e39b5192f89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b24fbd77bb2566fc819c610b88a41423c4e0e9b3278615f593e42d57904b74e8"
    sha256 cellar: :any_skip_relocation, ventura:        "fdad86891cf9b2ef01c6196639b31346fb97092d3605aa879939f8364760e49d"
    sha256 cellar: :any_skip_relocation, monterey:       "14b073501ea49f89cc20262478b4021a6b07290711202b66305d193930947d2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d35c892c8a4f486aed827acb7b760e44303a2d7e7abc4b4087a3e520432dd684"
    sha256 cellar: :any_skip_relocation, catalina:       "9c66b1e35b1c4eb718c3abae642c34666ea00a223b447b0d02fb81cd7f0183d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "357fb923776eb79ecc87788189897165bf733fd35d0fdd3a94e37cb73333b8d9"
  end

  depends_on "gradle" => :build
  depends_on "node@16" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/validation/check-environment.gradle",
      /expectedGradleVersion = '[^']+'/,
      "expectedGradleVersion = '#{Formula["gradle"].version}'"

    # Use yarn and node from Homebrew
    inreplace "gradle/node/yarn-projects.gradle", "download = true", "download = false"
    inreplace "build.gradle" do |s|
      s.gsub! "node: '16.13.0'", "node: '#{Formula["node@16"].version}'"
      s.gsub! "yarn: '1.22.15'", "yarn: '#{Formula["yarn"].version}'"
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
    fork { exec bin/"carrot2", "--port", port.to_s }
    sleep 20
    assert_match "Lingo", shell_output("curl -s localhost:#{port}/service/list")
  end
end

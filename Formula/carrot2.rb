class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.4.2",
      revision: "33dbd68df542e32700e42b930a75e29d1e64ee83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa61fd0d5efc0ef0c1da45cf36fc1c9c63b2efc17e34e2560954a75ba37d07ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd979a744c5552dc4026042d99492855122e8bfa9912a1aefec61012406d2d10"
    sha256 cellar: :any_skip_relocation, monterey:       "b4fcf3526dfe6fe7c3da96d842048d5e801690bffbaea1ea3a779a9c2274d453"
    sha256 cellar: :any_skip_relocation, big_sur:        "938cf87839d3cf6f72eb1905be5651a7bca907e53d81bf8115173a3136c1d750"
    sha256 cellar: :any_skip_relocation, catalina:       "2a8ed66de6badfb2be9353df69d6c98f21b39f7230eab75ff78fb305be59e067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d31c41cabf7fd6c9d6b7044c079f05cb1d540219798550258f231eea01f8549"
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

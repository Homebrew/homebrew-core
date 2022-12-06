class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.60.4.tar.gz"
  sha256 "ed5e94b1a0c4d28a6b98fdfec3799f2d0a136e499460059c66ee20aaa67b772e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a534eb77e47f1558bd2743cb4c440d5be87c7eab57bcb7449be2385409ab607"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f81e4e4f5843103e8e31ba8cca1a3ad9dfc342b45847af93975a9102e6eabfd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4c43d53235c753ffd6661b4b71dcf158fbe44f561ecf935075dcf9243e8602f"
    sha256 cellar: :any_skip_relocation, ventura:        "35c91872922abe38610fbc939ad13c1825972c9e012ed2748d726f679fb2dc69"
    sha256 cellar: :any_skip_relocation, monterey:       "58eb591a7bb177fecbacfea393e3860ee29e7fbc6a13fff28f89a30d07a6cc03"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab23a0f1ef8c21412dd3e67a22e5f8cafce9cc9d84817b5ad136a647679259f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3aa9ba3330acb8528a84bcadebb2d6e159514c57fef092a47db988a53b30980"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end

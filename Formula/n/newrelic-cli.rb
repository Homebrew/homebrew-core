class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.78.17.tar.gz"
  sha256 "5b75417ec8052b96854110df82fda264da354a1b10dd7c78350b7da569afb2d5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62dbdf9f3dc9eb5f6269c7b13185d37343f5af3eb42ffaa57c5ad51fc193511e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9299ecda23c3be738b40e759b83d347c52c53ffcdfc29225ed983af0177c3fae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa4551ef666593d6ccac43cf4b337d1a6ef1137af5175086ef75207576c06405"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f7bc86013b1e0e7b8d5ddcfe79275587e399ffbe36515b4a6186eeb7c9e050a"
    sha256 cellar: :any_skip_relocation, ventura:        "356a3bbcf843084ee805741fc5dda6ef7abb2755be2024072854b942d8c1c601"
    sha256 cellar: :any_skip_relocation, monterey:       "0ac9699002df22781692142a329640010a0e14a43eefb03af59f685378a8f901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd29b5bd6067fe5eaf208f8dcc670343ba95aac604e6bceed78d312e2640969"
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

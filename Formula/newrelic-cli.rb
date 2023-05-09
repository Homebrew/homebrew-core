class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.2.tar.gz"
  sha256 "48f056f2d4d4e875bf0de3f44df0ff3c6912049035932d4be9994de83cc562c6"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9331ea4682bd4343465862f44ff71d2878709e9404a63778f480732079c7add9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95bb8965312dfcb6cbfa0ac7d0a2e149654c8448a97fa3ba02a9634bc5f8cdac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95aa0ce1f0b3ef23fbacccc51875b2ed532e395ee35b4b49b2e2ba0d0dd1b1e4"
    sha256 cellar: :any_skip_relocation, ventura:        "82ef98292f20aa1e62d6406a7d0a16b4aaa057b4795f846ee86f3b129b02cd07"
    sha256 cellar: :any_skip_relocation, monterey:       "b415247ea3817925f695837d077936be6fcb30fe8d93eed267db63f84d7f6fca"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1a182c35e458958a2203b6323d70523adf44a99fecd5f46f8fc90b9969dfe1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64dd66818ccc4ede40f0e31870a37d633f4a64505badcab37ca14dfa84893643"
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

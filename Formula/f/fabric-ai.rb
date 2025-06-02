class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.195.tar.gz"
  sha256 "d4de84ea64f02a859d85cb5ae819602a393e94ac90a464ad6102d2132cb9e08e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77654bd6025e184891d09fc854fc333fc68387f448ec36b4f0dea007afdb3e25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77654bd6025e184891d09fc854fc333fc68387f448ec36b4f0dea007afdb3e25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77654bd6025e184891d09fc854fc333fc68387f448ec36b4f0dea007afdb3e25"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2763651c52e6c3636d916a1b6ef93a22c12838ebdd294a5ecd7a8c3e8264748"
    sha256 cellar: :any_skip_relocation, ventura:       "a2763651c52e6c3636d916a1b6ef93a22c12838ebdd294a5ecd7a8c3e8264748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b61af1d5b8180835a86fcb23c72b0fa1dc21be8d869b897c9b96321f2ca476"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end

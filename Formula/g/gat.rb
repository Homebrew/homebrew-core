class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "17536538142780aa9cc32dec491778e2fcbf783848ea30cb5aac553ed8e75812"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec2eb7915040c64071f99805b89cf8f99a9ff6e2153cd7a1b76c950bf6d0255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec2eb7915040c64071f99805b89cf8f99a9ff6e2153cd7a1b76c950bf6d0255"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eec2eb7915040c64071f99805b89cf8f99a9ff6e2153cd7a1b76c950bf6d0255"
    sha256 cellar: :any_skip_relocation, sonoma:        "16ba60b0033d44c46a382fc952c833199b81103685afbcfae6092b40d0996b16"
    sha256 cellar: :any_skip_relocation, ventura:       "16ba60b0033d44c46a382fc952c833199b81103685afbcfae6092b40d0996b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b81415e540ddd9020fbc64b1e3ed91fe43ecf4d42be57fe282540088c034296"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end

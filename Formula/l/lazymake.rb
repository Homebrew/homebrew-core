class Lazymake < Formula
  desc "Modern TUI for Makefiles"
  homepage "https://lazymake.vercel.app/"
  url "https://github.com/rshelekhov/lazymake/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "49dc29635990385fef22717d23c986a62803dc2afeeb428e0a1910711b169c37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fde256d4324ead2ab8eeae168e7e96303412904a0ba0841dc40d6412723636ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde256d4324ead2ab8eeae168e7e96303412904a0ba0841dc40d6412723636ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fde256d4324ead2ab8eeae168e7e96303412904a0ba0841dc40d6412723636ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbc451d4fb88a854b24fb0a45b3eac8c227caf4a54750823d6cff6255455021e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c118f176128b1beec7c5ea342e7755499be9f66e243bc02a43cd007a5e4de8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0eb1e4227a744cd748d06db64c7b2ea18fb252284dacbe60fa584b7335acbb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/lazymake"
  end

  test do
    # lazymake is a TUI, to verify the command is working we check the help output
    assert_match "Usage:", shell_output("#{bin}/lazymake --help")
  end
end

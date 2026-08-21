class Oxvg < Formula
  desc "Fastest SVG toolchain for optimisation, minification, linting, and actions"
  homepage "https://github.com/noahbald/oxvg"
  url "https://github.com/noahbald/oxvg/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "323c2e000ab8843d4e32f5ea3dd6ca7a76d42feb0c4a8e842381ba2b3b98fefa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f947ebb92ac9765aeea84184f5b0ae5dcc094de71a25c5c4fa5d90aefcd7a0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0865a21ebde5f679315bcbaee11dcb7e5d57b9c28964173b123585a5b7e4f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "991c839e499b336d70db087b65265b23d63804100d4935813be020c8813fc60f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6d8900fc4349ba7c933d13bade4d914243d119114ac6db1f79d446c8494453f"
    sha256 cellar: :any,                 arm64_linux:   "a401480510ba63c697706718b2ec33905f4e1ca62681b7fbf7b9315466d7dd90"
    sha256 cellar: :any,                 x86_64_linux:  "41ca622bc4fd806915a223f1cee604d0385618e81fd8e90e32c5f69a1ab1a150"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oxvg")
  end

  test do
    input = '<svg><path d="m0 0l0 1"/></svg>'
    assert_equal '<svg><path d="M0 0v1"/></svg>', pipe_output("#{bin}/oxvg optimise", input, 0)
  end
end

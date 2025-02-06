class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "829f6fb2e6f6d075dd959bd34349cf2edd90df052433a964b1dce93d5370e330"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "784002f8b6fc3393eba0099844fc860c41b7b4a488ce58872eb61745b0f97474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85a1b048d1e4bb1e6531bd9c1fedf70ef5556bee3f1720a04ee161fac06fdd9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "688cfca612a662d0254cd5265cd54869261fda37af9b6eba7b20ef17bb7a7258"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7bcb2b17f2d8d38c51e09bae0b2f691afc9d72a42c1705d60d9da416cce6796"
    sha256 cellar: :any_skip_relocation, ventura:       "83c814d66a38c0184b71330def4cfd53f94e32e674db8c874c52765811f6a818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e7b2c8272fad8c67732411937b34370e5a013bca3d273dd030ce5eef3e195d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end

class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.4.0",
    :revision => "d4c62007027e0e12b75d4d2099d92ec1278133b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec175c605e21ad2ab057eac32bea0c2d4b5234b72e66c8c90003bbdf8fcf953d" => :catalina
    sha256 "a3c55c43ce2bbb092ce2deedc6928fa61f3559705264e2e41ff85370a06fab08" => :mojave
    sha256 "cf2509b2f422ecb48778f9db8abb5b0f3c7abe727351fc955dc2dce4ae569fe9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output

    assert_match "failed to create config file", shell_output("#{bin}/cheat tar 2>&1", 1)
  end
end

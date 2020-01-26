class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.3.1",
    :revision => "3786ac96a526bc29695b3a3e0b6fb6df2c4e752a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3d39eb160b8a837d7bd05f6dbd06bfb5ee6588e5021f6ff020be1633bc1f0bf" => :catalina
    sha256 "77dc6e0148693bf8b217892f319dbcf14b4bf494d01b0c6360b8d5821e0c8501" => :mojave
    sha256 "d57f38d8efe1950378ae7b3e02ad4d7e6075a5147266f64e3f2f375a179563c4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output

    assert_match "could not locate config file", shell_output("#{bin}/cheat tar 2>&1", 1)
  end
end

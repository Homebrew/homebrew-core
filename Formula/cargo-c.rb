class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.5.1.tar.gz"
  sha256 "e547f3604bb801914d5685c22b54776baf70686b9aeb191396866a6e55391591"

  bottle do
    cellar :any_skip_relocation
    sha256 "5778730dfaa610a4bfc26b4d83eb3534842ff67e7c3799723ffe30f004d4e7d0" => :catalina
    sha256 "0f74fea38935d02e0245d816d5f7d1f7596f484d295099ba01c7de2140fbe5f8" => :mojave
    sha256 "3f464dcf67dc234aebdaee4c43f221453122f366cafaad7ca53deb0764dbe3de" => :high_sierra
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "cargo", "cinstall", "--version"
  end
end

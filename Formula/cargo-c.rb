class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.5.1.tar.gz"
  sha256 "e547f3604bb801914d5685c22b54776baf70686b9aeb191396866a6e55391591"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a92c381fcd6b88662ffcf27eb8bcab5376937f019a7b6e9a3912b9c82b4da71" => :catalina
    sha256 "36f68a6761b0738b5fb3ea77670eb20c4ccd82799b0ebd77f746a30641a65540" => :mojave
    sha256 "2de70b2fc069bb41bff1855e4f57154b023e4434c0886af8881a095b5b060ddf" => :high_sierra
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "cargo", "cinstall", "--version"
  end
end

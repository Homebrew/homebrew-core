class Fileql < Formula
  desc "Run SQL-like query on local files instead of database files using the GitQL SDK"
  homepage "https://github.com/AmrDeveloper/FileQL"
  url "https://github.com/AmrDeveloper/FileQL/archive/refs/tags/0.6.0.tar.gz"
  sha256 "cf0a420cf0cd634fe9b60e63718373458eeb25f210e1d2886791aa8a8703a2d7"
  license "MIT"
  head "https://github.com/AmrDeveloper/FileQL.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"fileql", "--version"
  end
end

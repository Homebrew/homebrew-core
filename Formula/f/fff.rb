class Fff < Formula
  desc "Simple file manager written in bash"
  homepage "https://github.com/dylanaraps/fff"
  url "https://github.com/dylanaraps/fff/archive/refs/tags/2.2.tar.gz"
  sha256 "45f6e1091986c892ea45e1ac82f2d7f5417cfb343dc569d2625b5980e6bcfb62"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a29ce06195d0e997c84daca50a89c6a22eb6ff81589974ea4e09601110989f25"
  end

  deprecate! date: "2024-05-04", because: :repo_archived
  disable! date: "2025-05-05", because: :repo_archived

  def install
    bin.install "fff"
    man1.install "fff.1"
  end

  test do
    system bin/"fff", "-v"
  end
end

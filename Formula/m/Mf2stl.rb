class Mf2stl < Formula
  desc "Command-line utility to convert 3MF files to STL format"
  homepage "https://github.com/lemgandi/3mf2stl"
  url "https://github.com/lemgandi/3mf2stl.git", branch: "master"
  version "1.0.0"
  license "GPL-3.0-only"

  depends_on "libzip"

  def install
    system "make"
    bin.install "3mf2stl"
  end
end

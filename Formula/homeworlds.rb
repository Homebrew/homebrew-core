class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds.git",
      revision: "917cd7e7e6d0a5cdfcc56cd69b41e3e80b671cde"
  version "20141022"
  license "BSD-2-Clause"
  revision 2

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41ae22b1d2498f7a00855e911ef7087ab62d8cd0834e16d8780e30c8d23b228a"
    sha256 cellar: :any,                 arm64_big_sur:  "3abc2449ee3237a932c4250e0c36dbf76de53babb12a6cdfaac8b08e19552c20"
    sha256 cellar: :any,                 monterey:       "689f42e85f625d840df24df8a43c21927c6e6d816ff290a9eddbb7f733c2508d"
    sha256 cellar: :any,                 big_sur:        "81327f370fe9de62e68197c054d5929788aa4b32731769b053d4ab893f0aa631"
    sha256 cellar: :any,                 catalina:       "b7bf80945586bd38e4f2a7a888d55ab46dd6210a069d327d536713fb20e985c3"
    sha256 cellar: :any,                 mojave:         "34c292eab868e7e49b00653f1f8022e8636370ee2510e50e44720b37c6774bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3766f96986bd5604d0d4cefd0a07f3a6e527fdf6f70e70d3e22dac01198a2879"
  end

  depends_on "wxwidgets"

  def install
    system "make"
    bin.install "wxgui" => "homeworlds-wx", "annotate" => "homeworlds-cli"
  end
end

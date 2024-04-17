class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.5.28.tar.gz"
  sha256 "478392a48fabbfab70b53b1aa2f5d4fda329872c1436044ee786874ff7f495d2"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b42f9176baf2443e658aa8d08499c80d7dbda0f8833921e3fd2af084cc68abbc"
    sha256 cellar: :any,                 arm64_ventura:  "0e79398ef63f174cb8bce9ae721c0071b65f4a5eaab090ae152cba7ccfeb986b"
    sha256 cellar: :any,                 arm64_monterey: "d3484dd41735a81362c57c02c674d9026c1ff7a2f952d9bd85dff00c1d26335a"
    sha256 cellar: :any,                 sonoma:         "24c319cc1fb8c9382e0f4b9182ab931edfbd808ee68ace7bc2c5a1cfc7ec084a"
    sha256 cellar: :any,                 ventura:        "8ae967c3ac5128e08901a557a158fb359a7070697719dbaa4be1f5f6443ffb2f"
    sha256 cellar: :any,                 monterey:       "28f38bba58a61c62f2a698bba05f80ad07dee52525edaf83ff421de06ca28f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "334a49cbc17b72f0ec442ca3890c6052ce36f7f6b3de09d083658b2bd2200784"
  end

  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end

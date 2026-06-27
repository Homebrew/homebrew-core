class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.9.33.tar.gz"
  sha256 "3b807837b8458609b37e107fa063160298ee3655998dd8df590885c297af1fd3"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "51b1148db76cc4676500b5b74efe442f701ccac228a0475d26f15d1dd56f772a"
    sha256 cellar: :any, arm64_sequoia: "94859a5240b112f3e4b1d76daf2881d6084ab1e87bfff68e2dde4d26dfdc2541"
    sha256 cellar: :any, arm64_sonoma:  "0fa39ce1caa4354d28cc7f47323fe3e1af178b142805170b50a2311726fa6851"
    sha256 cellar: :any, sonoma:        "f095b93a4993ee60d1346d8211a70cfb18caf135b26da4e553cde6e2f2438e8f"
    sha256 cellar: :any, arm64_linux:   "8c7b4f28310ec808bf9e28493c0b058baa96a3e8f09028b52a9a261c3db2dde6"
    sha256 cellar: :any, x86_64_linux:  "099e489d304a12b7d0a06ed4a9b6fe7abf6acb509834cb6cc532e7fd52f2d02f"
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CURSESLIB=-lncurses", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end

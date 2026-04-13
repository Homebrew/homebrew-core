class Genext2fs < Formula
  desc "Generates an ext2 filesystem as a normal (non-root) user"
  homepage "https://genext2fs.sourceforge.net/"
  url "https://github.com/bestouff/genext2fs/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b8aba9af48e664fa60134af696a57b3bb4ebd2b2878533d7611734e90b883ecc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21f58d67f7b4979133013a4afd31c5cc4aaca8880d3cd45d66051029c28f579a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "651094e32c8755021d58d7a1d6c4c7839ef4eec1ceed66d29c74cb8e4e07d9bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b1f88dcf000f4cedd232f77a8848a040adbabd02172fcb029a476668ec5708a"
    sha256 cellar: :any_skip_relocation, sonoma:        "40fcbb32c1aa62ca0bfab62147eb53c4c6743d53d7234abd1c9ed50bf31ad787"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd2b569822378fce78f9bc56698aab03be94ef56b8620a22c0e89136ec1dcfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6534830d59287283bcabbb86cf09e73db7dac58d578a3dedcc4e0266b2466f3a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    rootpath = testpath/"img"
    (rootpath/"foo.txt").write "hello world"
    system bin/"genext2fs", "--root", rootpath,
                               "--block-size", "4096",
                               "--size-in-blocks", "100",
                               "#{testpath}/test.img"
  end
end

class Genext2fs < Formula
  desc "Generates an ext2 filesystem as a normal (non-root) user"
  homepage "https://genext2fs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/genext2fs/genext2fs/1.4.1/genext2fs-1.4.1.tar.gz"
  sha256 "404dbbfa7a86a6c3de8225c8da254d026b17fd288e05cec4df2cc7e1f4feecfc"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a22f21cd781def8a9c4f89eee4158c1ad525766f2bb2d54aa1d00362c399706" => :mojave
    sha256 "b74a72de535c529c5c5aa9ac3b77618e6f95f8114ded59e7e84124a829b6bb16" => :high_sierra
    sha256 "82ac8092d73d2f81fd0770b15bad060f4f3b010c089a0cda5131f9bcec3318ea" => :sierra
    sha256 "3842e46ce4c24b75364337fbe4a10243cd01a8aaf4b51feca6631c7cf0649aa6" => :el_capitan
    sha256 "acdca2f9efcacafc7f105a43837a2f36e42dca1fd1325d62f9e5327797c69164" => :yosemite
    sha256 "f8f37e86e32de96736daac7b2b24594647e28d2b1610ccd68237d028d9b4dd43" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/genext2fs", "--root", testpath,
                               "--size-in-blocks", "20",
                               "#{testpath}/test.img"
  end
end

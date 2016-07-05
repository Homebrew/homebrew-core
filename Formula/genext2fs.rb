class Genext2fs < Formula
  desc "Generates an ext2 filesystem as a normal (non-root) user"
  homepage "http://genext2fs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/genext2fs/genext2fs/1.4.1/genext2fs-1.4.1.tar.gz"
  sha256 "404dbbfa7a86a6c3de8225c8da254d026b17fd288e05cec4df2cc7e1f4feecfc"

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

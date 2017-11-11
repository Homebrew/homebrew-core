class E2tools < Formula
  desc "Utilities to read, write, and manipulate files in ext2/3/4 filesystems"
  homepage "http://home.earthlink.net/~k_sheff/sw/e2tools/"
  url "http://home.earthlink.net/~k_sheff/sw/e2tools/e2tools-0.0.16.tar.gz"
  sha256 "4e3c8e17786ccc03fc9fb4145724edf332bb50e1b3c91b6f33e0e3a54861949b"

  depends_on "e2fsprogs"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system Formula["e2fsprogs"].opt_sbin/"mkfs.ext2", "test.raw", "1024"
    assert_match "lost+found", shell_output("#{bin}/e2ls test.raw")
  end
end

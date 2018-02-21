class Dollop < Formula
  desc "Creates files with pseudo-random content (dollop)"
  homepage "https://robertomachorro.github.io/dollop/"
  url "https://github.com/RobertoMachorro/dollop/raw/archive/dollop-1.0.tar.gz"
  sha256 "07e799f8a59fc1014f762f7816d8013788a3762946dda635fa2504e6713ba5b7"
  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    system "#{bin}/dollop"
  end
end

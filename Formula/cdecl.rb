class Cdecl < Formula
  desc "Compose and decipher C (or C++) type declarations or casts."
  homepage "https://github.com/paul-j-lucas/cdecl"
  url "https://github.com/paul-j-lucas/cdecl/releases/download/cdecl-3.0.1/cdecl-3.0.1.tar.gz"
  sha256 "68437d334f1392f2e0555ae65cc9de5e13d8f9d13f9363e893c90d9654e11e37"

  def install
    ENV.deparallelize # must ensure parser.h builds first

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "declare p as pointer to int",
                 shell_output("#{bin}/cdecl explain 'int *p'").strip
  end
end

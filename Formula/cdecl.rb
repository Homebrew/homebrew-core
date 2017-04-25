class Cdecl < Formula
  desc "Compose and decipher C (or C++) type declarations or casts."
  homepage "https://github.com/paul-j-lucas/cdecl"
  url "https://github.com/paul-j-lucas/cdecl/releases/download/cdecl-3.0.1/cdecl-3.0.1.tar.gz"
  sha256 "68437d334f1392f2e0555ae65cc9de5e13d8f9d13f9363e893c90d9654e11e37"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d424613881cf9109d824664fc77fc947f2968b9850d448db4b02c6f0a562b5c" => :sierra
    sha256 "4f0e990d88823aa9f3d1dcea71ffa442c13640ce82cc9da41f90a1be5ef457dc" => :el_capitan
    sha256 "e8f53a0e5b3649f0c691c60380b9c77af573387240f3479a41550583fcc4e22c" => :yosemite
    sha256 "b1e1618d0f1bcbb801c669c314c36c72e47e8829950a8bf0899d0517f3036ccc" => :mavericks
  end

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

class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https://cdecl.org/"
  url "https://cdecl.org/files/cdecl-blocks-2.5.tar.gz"
  sha256 "9ee6402be7e4f5bb5e6ee60c6b9ea3862935bf070e6cecd0ab0842305406f3ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d424613881cf9109d824664fc77fc947f2968b9850d448db4b02c6f0a562b5c" => :sierra
    sha256 "4f0e990d88823aa9f3d1dcea71ffa442c13640ce82cc9da41f90a1be5ef457dc" => :el_capitan
    sha256 "e8f53a0e5b3649f0c691c60380b9c77af573387240f3479a41550583fcc4e22c" => :yosemite
    sha256 "b1e1618d0f1bcbb801c669c314c36c72e47e8829950a8bf0899d0517f3036ccc" => :mavericks
  end

  def install
    # Fix namespace clash with Lion's getline
    inreplace "cdecl.c", "getline", "cdecl_getline"

    bin.mkpath
    man1.mkpath

    ENV.append "CFLAGS", "-DBSD -DUSE_READLINE -std=gnu89"

    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LIBS=-lreadline",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    assert_equal "declare a as pointer to int",
                 shell_output("#{bin}/cdecl explain int *a").strip
  end
end

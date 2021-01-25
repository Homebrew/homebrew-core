class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.4.tar.bz2"
  sha256 "c080ee96b3bd519edd696cfcebdecf19a3952189178db9887be713ccbcb5fbf0"
  license "GPL-3.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libassuan/"
    regex(/href=.*?libassuan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "d8ea4992e20e4c9667446e57a4f6228f81134f9e4556a4e3aab86911044371f5" => :big_sur
    sha256 "954bf0a0e5e1e639fe0846d99ffce6900470774dc2caf38e6ae72dd611732c73" => :arm64_big_sur
    sha256 "e605a00c83f3a0dc2a938b3c44894ca150383223c059c712e87480f4f63f0411" => :catalina
    sha256 "be3c6bfb29b520cb0a35aaca1a59d4f2ed85f6ec84a508f0a0e1702509a567a0" => :mojave
    sha256 "eda33cb3a7e0f07d7ed67ab01067bc528d1169a745a538a3c5a8f8f114f2a9a9" => :high_sierra
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libassuan-config", prefix, opt_prefix
  end

  test do
    system bin/"libassuan-config", "--version"
  end
end

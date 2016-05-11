class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.3.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.4.tar.bz2"
  sha256 "f6c2883cebec5608692d8730843d87f237c0964d923bbe7aa89c05f20558ad4f"

  bottle do
    cellar :any
    sha256 "f455678eb6f38f3c0d07b174b4c2f1b8d3a034b64996f0db9ea14ad559e2fbcb" => :el_capitan
    sha256 "6ac68b0bd118c3f1e0440af4f805b75e925f4c2dde6ab466fb117323ac23dc92" => :yosemite
    sha256 "38108681341eae8a7b196c356ad790f265663f794c5eb7eea5378579c920356b" => :mavericks
    sha256 "b0428dd17c910797a627f9a7d85ee1bc6deeb0a3354d2aaa1bf400ceb6ad682c" => :mountain_lion
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end

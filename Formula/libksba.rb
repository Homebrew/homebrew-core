class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.0.tar.bz2"
  sha256 "dad683e6f2d915d880aa4bed5cea9a115690b8935b78a1bbe01669189307a48b"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f42646b71493d1057c50d7b806ecf4ef56dee5c41add78aca6667b1ea566b197"
    sha256 cellar: :any, big_sur:       "b594a0f8a1347e11eaa2f28a6f6514bce719f51ffa16cf6a1f09cda5d9826b52"
    sha256 cellar: :any, catalina:      "3b30f0648ffa980e26ba8bc87f0c906fdc757db0faf2ed25065eb22108517c4d"
    sha256 cellar: :any, mojave:        "c3cecb6086e75ae6727b55449caab78a4ae09995a90beda5f34d6c816b4afffa"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"ksba-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end

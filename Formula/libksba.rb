class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.3.tar.bz2"
  sha256 "3f72c68db30971ebbf14367527719423f0a4d5f8103fc9f4a1c01a9fa440de5c"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0829951404543f9d9a6072f53c116accf7ad7265f5bad77d3e5aeb350a655bac"
    sha256 cellar: :any,                 arm64_monterey: "62b24304adae5bfa956619c08dc2374a7ea32fac01e7e61752ce092248cfd492"
    sha256 cellar: :any,                 arm64_big_sur:  "e241f911ebb383762bfdc069e7c6ba8c918cd4cb480450dcdb3adcf34de91f40"
    sha256 cellar: :any,                 ventura:        "1eac027cf29220a012d336ee078a3ebe539402cd468c9b6dbeb5b5c4669d14c2"
    sha256 cellar: :any,                 monterey:       "bd26b1d6a289ed0c534f5fdf0e8784a6e1c2a17b1306c28488b2679806c8d4a8"
    sha256 cellar: :any,                 big_sur:        "50f9fee0ebafae230e2305dd4b5a4a0d48575f831ee05b1c169e6ede9235ccf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "763d7323bba76405c4bed96b18c86ad20569d6699f16965ecc74cf9ddcb857fa"
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

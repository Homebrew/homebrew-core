class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.26.tar.xz"
  sha256 "6cfc488344cef189267e60aea481f00d4c7e2a59b53c6c659c520a4d121f66d8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9b5033e58a0c952161ece88e2b4c554af6e7c171e7e740bf02aa5f2e74767041"
    sha256 arm64_ventura:  "56711594d87c2709e82f626e1d8296b71aa9b1071d214bc0a8c00d2a7ddeb956"
    sha256 arm64_monterey: "f6298cd53a86c6b7dc877598260ff2f0d5b93a51dd3a93d49e090365e1721a40"
    sha256 sonoma:         "87c6b49b175acd851200467f401a492e6c7cdf53ea564e5fd7bb6e2265866cdd"
    sha256 ventura:        "8a14bfa72ab0de378e8e7b840165105c7cd7f1434ca2bd4bd53536378aea03f4"
    sha256 monterey:       "10ff50baba4c580c49131bf41773ce9cf979fb1d1d3162f87255bdce0190868f"
    sha256 x86_64_linux:   "71df3b5a4e31df54427f47a395df4506704fd495995cc807f8aad54131088b09"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--with-macosx-keyring"
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end

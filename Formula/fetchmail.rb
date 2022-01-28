class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.27.tar.xz"
  sha256 "9e64f9e71f798cf1fe2278b84e2f5880b806527c0c0206925c086ccd179113dc"
  license all_of: [
    "LGPL-2.1-or-later",
    "ISC",
    "BSD-3-Clause",
    :public_domain,
    "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" },
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "161666bcda0f51f37f6c16a6d55076607e4c7205606d44ddabfbf7a121efff9d"
    sha256 cellar: :any, arm64_big_sur:  "066ed2ae6f197a1bb45330490f8cb7e849078ef65f8a7c0c8d148d488c72cbff"
    sha256 cellar: :any, monterey:       "249eb1d454831cef4edeb25a2367fe3b6283a6d5ce7dc28a698cf880e686e7dd"
    sha256 cellar: :any, big_sur:        "b00368768c8922854dbb60eb597c41ba94f2499f65b8147e8330c92b337fedf4"
    sha256 cellar: :any, catalina:       "c550c43acbba8dd989d091f8c7f123fcd9134a9fd429dbcf6efd6758777be1b6"
    sha256               x86_64_linux:   "4eb5ead9a81458ad7dc12e87451a9f398d656b54252c4f04e799db9cd3eb7cd7"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end

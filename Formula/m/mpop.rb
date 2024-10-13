class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.20.tar.xz"
  sha256 "35cc7de17e3ddaca4743863464488f8c82a83ac1b3764fddd7f423881435bf4b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "a569988b1465027742d25890bdd39e274b425723104b33ca2f0cf76978408d05"
    sha256 arm64_sonoma:   "119c3049a55e441db8bd727062cb56fb52f93fe6b7d792c813bfb39acf534e3c"
    sha256 arm64_ventura:  "3e00c1f1065249d076e8837ec34695c18f0627f8f16acd15e937b723124b8b24"
    sha256 arm64_monterey: "7ecefccf4e929b82eb91685028bd77ef9f287b1ac1c670c88f831a321b297b9a"
    sha256 sonoma:         "7d049ac0af55ff5510d66cd1a18b000d3b566d5a3b7aae57444b50542189b6e2"
    sha256 ventura:        "e1d6c12ab104458eae858ad6a04f6c259c89e2536eca6ac8e8eace862c834c66"
    sha256 monterey:       "ec5867a8b3a654605715b5f58a5117069f21954e41c37cdde6b7e8156124a231"
    sha256 x86_64_linux:   "6b216878830d207454e6327c2c5ca7960c44dd237304c9346a47d80c2d81db68"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end

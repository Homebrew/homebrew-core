class Nfcutils < Formula
  desc "Near Field Communication (NFC) tools under POSIX systems"
  homepage "https://github.com/nfc-tools/nfcutils"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/nfc-tools/nfcutils-0.3.2.tar.gz"
  sha256 "dea258774bd08c8b7ff65e9bed2a449b24ed8736326b1bb83610248e697c7f1b"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f52daea8355a598eb9226fb170019d92e831ad54dbc11eea3473a42ad34262c"
    sha256 cellar: :any,                 arm64_monterey: "d502000cd5655c0ec554e4789b846582cc8421bf69a79d1df7ffaeb0f497af9c"
    sha256 cellar: :any,                 arm64_big_sur:  "257b8265cf3e136dd2a11c3b26b37f31cc3de371d97401a5fadaf1681330fbd8"
    sha256 cellar: :any,                 ventura:        "a2675c309347279b2a0373bea9335e99bdb45973c53c95420f120a8e168114b8"
    sha256 cellar: :any,                 monterey:       "835a1d70f054d1eb3a05947f085331948024d3b2daa75dd7fd8e46e2ec84f9e0"
    sha256 cellar: :any,                 big_sur:        "ae40ef6e8f1d98d6fc6114893715c713c28e0747a5c5a84779c89726970f8a95"
    sha256 cellar: :any,                 catalina:       "963e5bf77bc285e81b9f7480f8b0362c73e5138bced77608043742df6e0992cd"
    sha256 cellar: :any,                 mojave:         "972af2e69529bde17b450d36ccfbb4b9d124c59beb7bb4d69a9c63b76f7cff58"
    sha256 cellar: :any,                 high_sierra:    "44dc64d49e9edc0c7b8f22c7f259262d5706f83bb452099b968b9f3576047367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f32645957380142c3180b1c67f9afb4170caa582aae8e0500731700d170dbc6"
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "libusb"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

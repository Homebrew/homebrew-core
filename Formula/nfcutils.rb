class Nfcutils < Formula
  desc "Near Field Communication (NFC) tools under POSIX systems"
  homepage "https://github.com/nfc-tools/nfcutils"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/nfc-tools/nfcutils-0.3.2.tar.gz"
  sha256 "dea258774bd08c8b7ff65e9bed2a449b24ed8736326b1bb83610248e697c7f1b"

  bottle do
    cellar :any
    sha256 "c3613016a9997eed8a6ec6bec027ea5abd928f648e227a22982f862ab471db36" => :catalina
    sha256 "5eaf6ffe3b96a94d1b6fbc150473aa6684dd98bca031b0a69883ca919467feb4" => :mojave
    sha256 "bb263a7a1a406e79c94e97cd3ea7dd1ab4894f7d91ed8246c22b30957b83f897" => :high_sierra
    sha256 "3f0145b6a563c0f401f567fb314a1485b3a5bc9b3a843f53d8d1fda72492b8fa" => :sierra
    sha256 "ae0ac5663ac10557da9d42a12986268f5ab6149661c8e394df5a314b405d3b30" => :el_capitan
    sha256 "24217bb0697bfde3272b966d664ed7e1d40c0c986207ea7f7edef84862302a9d" => :yosemite
    sha256 "9c116d6d84f06a70e271b87268be451dc082a4e191e5cbeeb1a0cb6384f21e1d" => :mavericks
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

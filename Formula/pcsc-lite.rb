class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.7.tar.bz2"
  sha256 "92c1ef6e94170ac06c9c48319a455ad6de5bcc60d9d055a823b72a2f4ff3e466"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "17e6cb349aefe800146d4b4b8cf75abab4ae9bf2b6f2b8511d7ec8ed0cfa9197"
    sha256 cellar: :any,                 arm64_big_sur:  "437f701af5afd212c9152e6b11de999f9c6100b77d1606eb7237763a26d0645a"
    sha256 cellar: :any,                 monterey:       "e9f81a760a0363795043b725c93322c5df5dede0de88984d3d956434b9d32cc5"
    sha256 cellar: :any,                 big_sur:        "915ba0331656b8463dbbda4de60e2054b4f5dc13fc97d1a65aad2ad171530285"
    sha256 cellar: :any,                 catalina:       "33667140732cfe511d2a89f35691cec9ceb90b81b2a547353c7019741593d159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50bc56ac761233682201019b580ce7f6e0124f48736b0e146c62d45391a4c22d"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    args = %W[--disable-dependency-tracking
              --disable-silent-rules
              --prefix=#{prefix}
              --sysconfdir=#{etc}
              --disable-libsystemd]

    args << "--disable-udev" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end

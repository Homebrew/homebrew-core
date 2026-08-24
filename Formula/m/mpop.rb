class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.23.tar.xz"
  sha256 "02fc2ff44f62b8fbf427ed6d8b16e0d374751198254fb1e6ad36eb6d9a938017"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e6c27bfca49caf2fd741cec067bed4f15b3fcc5974b0a84ea608d89a3b7f32bb"
    sha256 cellar: :any, arm64_sequoia: "7e068e36b842bd8fb000b54bf191d1b407fe66749a07bf9f92b8a7aa7cc3a7dd"
    sha256 cellar: :any, arm64_sonoma:  "7440c5d35141cae1d92e437bf8bf9a60f05fbd9b9361eb92d5d8c7679a952b0b"
    sha256 cellar: :any, sonoma:        "5e79be4e95de101a56ca22a345bfa86abfa60bc2f2e04d6dbf01d45b6bd6f4c2"
    sha256               arm64_linux:   "43f048d0e7db1270d90445c58e8965da8f25dfff487678bc631709f619e55a13"
    sha256               x86_64_linux:  "d4eb464313aaa8621da76138c97d8fcba126045be9fcf35929d608f85ad81113"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libidn2"

  on_macos do
    depends_on "gettext"
  end

  def install
    # gnulib's base64.h (vendored in 1.4.22) uses `bool` without including
    # <stdbool.h>, assuming C23. Force the include for pre-C23 compilers.
    ENV.append "CFLAGS", "-include stdbool.h"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end

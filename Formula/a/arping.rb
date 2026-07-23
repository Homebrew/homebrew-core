class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/refs/tags/arping-2.29.tar.gz"
  sha256 "387955d6ba8eedcf242bb3784bebf8e40fad39703117e21e02cec12820990a5c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "25dba4967ef50f57082286ba82b3fb5e9e921c5a2bad0f39a3376163fa306d21"
    sha256 cellar: :any, arm64_sequoia: "1a359d4a111ed2c09ca3a1b4785d79639ad1a7b5d19fa9b69de07455dea673eb"
    sha256 cellar: :any, arm64_sonoma:  "a741cd57ca5ab1b0a4b3768a9520a0648c7b391667e5b3d2d5732c575b73f49f"
    sha256 cellar: :any, sonoma:        "8f3fa85c579d98901338b021a7bf319c001dfd368d4c0ab581813a1312d59077"
    sha256 cellar: :any, arm64_linux:   "9a1e907a064c6ee8591c3a16cfb724159931e40d39c57d068a7bbb33bf840b62"
    sha256 cellar: :any, x86_64_linux:  "e171219ab884938ae1b3885e31464246cd3b6058ad865d9fcd3278740c91b5f8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system sbin/"arping", "--help"
  end
end

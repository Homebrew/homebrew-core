class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0546a5e9cadb4d0e3959383c9c751b53c3cd53d643f3c4e0eb83802d7eea1aed"
    sha256 cellar: :any,                 arm64_monterey: "83f89191a353e41ed16c771a240dcc3f474558807a6796edb1c5c3930cadaa41"
    sha256 cellar: :any,                 arm64_big_sur:  "ca391cf3436bbe61806a2107f3b4229fdee1d077bc4b91117afaa8b8ace5f361"
    sha256 cellar: :any,                 ventura:        "5f5a943e524f95b4d71221748ac6997a59ce2ba419a28a417f0fa1247f9084f0"
    sha256 cellar: :any,                 monterey:       "529d7ca3089ed1ce09c2fba2cbec952aa08e3245d8ea360341fa961d1bad6ed9"
    sha256 cellar: :any,                 big_sur:        "2cc0d541e3b5e2ac9238a6bb6d3677c97e5a863b8bdc6894f1ed6501264093a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b3819088a3a5963d0e428e5c102c1ece212e854f0416c74072e1f96f70056b7"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
  end

  def install
    ENV.cxx11

    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Keep C++ standard in sync with abseil.rb
    ENV.append "CXXFLAGS", "-std=c++17"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end

class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "d93ec9b2b0a012f59c4b8d5902b8a70b45db01e32c7c1ef7e5acd84ecebbb95f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cd5e65fefe77158948b9ca62111bf2be92eeb0cfa9f1c947fbc7a47d5aafbb90"
    sha256 cellar: :any,                 arm64_big_sur:  "350f6da7e527462bc3d23e8a0e5e0b27a142dc23e559d84db3c85a19b464aa16"
    sha256 cellar: :any,                 monterey:       "4ed43c909f0032e01d2aa62814480cc48d25180df72ec2036343783f9ca6eb6f"
    sha256 cellar: :any,                 big_sur:        "18eda8018036804beaa7fa9c57e3cc58afd0142021cf3d81ddd638e27287b395"
    sha256 cellar: :any,                 catalina:       "d206e09c499790891f1ed62f7926046e07359a7510e22a7b010ed6a8d6917989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bab92d02ff8ee5d16017e4aee5981c99bca64e6c07ae404101b57762b65f4d6"
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
    depends_on "openssl@1.1" # Uses CommonCrypto on macOS
  end

  def install
    ENV.cxx11

    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end

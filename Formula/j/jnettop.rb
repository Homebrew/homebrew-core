class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  homepage "https://sourceforge.net/projects/jnettop/"
  url "https://downloads.sourceforge.net/project/jnettop/jnettop/0.13/jnettop-0.13.0.tar.gz"
  sha256 "a005d6fa775a85ff9ee91386e25505d8bdd93bc65033f1928327c98f5e099a62"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/jnettop[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "0718bfddbc7db4199af6d06c8410cb25e1c19fa8199e77399b8711bd4537a24c"
    sha256 cellar: :any,                 arm64_sequoia: "cafcb2e1c6f02334c406bb7ff8b7d73e3caf1a728dd45f1c68dbf69bd4516252"
    sha256 cellar: :any,                 arm64_sonoma:  "a4d177c35919b5b7f27097739b860e60834e1384a78082fd6e169afc0f0e2621"
    sha256 cellar: :any,                 sonoma:        "4b1574c7eb8c5245d4f25a876361c6ddcd1784d9dd73dd65487fbaf212fc8103"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdc34f37d6af5d676d8aac29edd603b27eed4a4e2ed53417699c4b79e52b4828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8f2c08236725ce449e6fc09b1864113a87a9c5abd08450707e6007d8f178533"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    # Fix undefined reference to `g_thread_init'
    if OS.linux?
      inreplace "Makefile.in", "$(jnettop_LDFLAGS) $(jnettop_OBJECTS)",
                               "$(jnettop_OBJECTS) $(AM_LDFLAGS) $(LDFLAGS) $(jnettop_LDFLAGS)"
    end

    system "./configure", "--man=#{man}", "--without-db4", *std_configure_args
    system "make", "install"
  end

  test do
    # need sudo access to capture packets
    assert_match version.to_s, shell_output("#{bin}/jnettop --version")
  end
end

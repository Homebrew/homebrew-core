class Poke < Formula
  desc "Extensible editor for structured binary data"
  homepage "https://jemarch.net/poke"
  url "https://ftpmirror.gnu.org/gnu/poke/poke-4.3.tar.gz"
  sha256 "a84cb9175d50d45a411f2481fd0662b83cb32ce517316b889cfb570819579373"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "821eefd5e063b58af3ef23658e016cbed9d7869c9dce45f832d8da03b4db559a"
    sha256 arm64_sequoia: "70cac0d1d59525b97a594c9a16eab3797419b766608dd48fb0490941e0e96ea8"
    sha256 arm64_sonoma:  "96c98aed96e957144166238b78d28199876e6a4e1c45e1bbc3ab94d84826db13"
    sha256 arm64_ventura: "07539d167175536ece64fdef868664dec7dd8631ddc0ee3b2a66a1d08c76c00d"
    sha256 sonoma:        "109401dd79744517c3d41bb73108fc778e3dd8dbc8b31032cfc70dbc06b5c12d"
    sha256 ventura:       "4262e197f77325c4871dd782ee3a8952f996f24af723d1fc4504055aa19784f8"
    sha256 arm64_linux:   "e9f8c5b017fbc20596b897784e4bbea573085a3bb243d39d5a901ada5f63189c"
    sha256 x86_64_linux:  "016bf647c3fad54272c7efde148cb755cd9015e3b3c7d394937f36a201667773"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "bdw-gc"
  depends_on "gettext"
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-silent-rules", "--with-lispdir=#{elisp}", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.pk").write <<~EOS
      .file #{bin}/poke
      dump :size 4#B :ruler 0 :ascii 0
      .exit
    EOS
    if OS.mac?
      assert_match "00000000: cffa edfe", shell_output("#{bin}/poke --quiet -s test.pk")
    else
      assert_match "00000000: 7f45 4c46", shell_output("#{bin}/poke --quiet -s test.pk")
    end
  end
end

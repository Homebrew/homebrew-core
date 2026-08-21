class Poke < Formula
  desc "Extensible editor for structured binary data"
  homepage "https://jemarch.net/poke"
  url "https://ftpmirror.gnu.org/gnu/poke/poke-5.0.tar.gz"
  sha256 "6873d59abe821c8111b88623ea7ad9e090892fa95c75562606dd88374e2f5b8f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "28d460a367b8e841626484f9eab13782ce77f08dc5540279ef6383045b513592"
    sha256 arm64_sequoia: "bc8a3b20c5fcec70416f76a2de3cc298261195f34b2d33abdec30e539c1f6862"
    sha256 arm64_sonoma:  "97a987881541e06a6efff389af06040f5e38dc8f7a836be9f1abe6c3f74e32c3"
    sha256 sonoma:        "d6ac0c4a21d696d058c50c5eb95694eb334ae2c85425deac6ca7a6f3415fdb0f"
    sha256 arm64_linux:   "47c44c4736f985ed41a8fa1e0589c4e959ccc258bbe933c25be18d479508f388"
    sha256 x86_64_linux:  "b16549a3bc7696f3557f2bdd285b2bed5ea748b1b00bfb417519cc5e103b33ce"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "gettext" # needs libtextstyle
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-silent-rules", "--with-lispdir=#{elisp}", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.pk").write <<~PK
      .file #{bin}/poke
      dump :size 4#B :ruler 0 :ascii 0
      .exit
    PK
    if OS.mac?
      assert_match "00000000: cffa edfe", shell_output("#{bin}/poke --quiet -s test.pk")
    else
      assert_match "00000000: 7f45 4c46", shell_output("#{bin}/poke --quiet -s test.pk")
    end
  end
end

class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftpmirror.gnu.org/groff/groff-1.25.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/groff/groff-1.25.0.tar.gz"
  sha256 "24d103a07eb79e418963bce206c8771b649871f83bda2fd4c2e65529c1c56921"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "ea2d8950c93c1e203086905878ff6f277e8faaf4fa45e4da82e98d7b8d16d492"
    sha256 arm64_tahoe:       "68e14746516c3e7381cf92b3b3402421c407ae552cfacfa97953921343c5d91d"
    sha256 arm64_sequoia:     "831040cedb3140fd0293677be39198e162211db7bc40aeae5c8b9844b9f756d0"
    sha256 arm64_linux:       "a267648fd295b705e90feffa7803e91953c976c791d2c8fadb0e22181bf31fd0"
    sha256 x86_64_linux:      "c62748d70e2c9565f1b41388308ae80e823d6b1ffe493220b07548c3859a6e67"
  end

  depends_on "pkgconf" => :build
  depends_on "ghostscript"
  depends_on "netpbm"
  depends_on "psutils"
  depends_on "uchardet"

  uses_from_macos "bison" => :build
  uses_from_macos "perl"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "glib"
  end

  deny_network_access!

  def install
    # Local config needs to survive upgrades
    inreplace "Makefile.in" do |s|
      s.change_make_var! "localfontdir", "@sysconfdir@/groff/site-font"
      s.change_make_var! "localtmacdir", "@sysconfdir@/groff/site-tmac"
    end
    # Upstream still uses K&R function definitions, which do not compile as C23.
    ENV["ac_cv_prog_cc_c23"] = "no"
    system "./configure", "--sysconfdir=#{etc}",
                          "--without-x",
                          "--with-uchardet",
                          *std_configure_args
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n", pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end

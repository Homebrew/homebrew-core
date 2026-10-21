class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftpmirror.gnu.org/groff/groff-1.24.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/groff/groff-1.24.2.tar.gz"
  sha256 "f9c1efd5bebbe37fc6e1063db7473ce8df1e3e0be4ff0f43ce04fce57e9c5dd9"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "6137ba5da230ae248b2ef6e7c9559059c555f8318401667eaa5692765bb02a10"
    sha256 arm64_tahoe:       "c40cfaa1386664af0e5744ae609a83e278abf21b1fcac4e112ea5442b618525b"
    sha256 arm64_sequoia:     "f7ee5153d808e5bdf5b7e7f0bf825c6afd2cda29970a8e45dabfb7c24bc07994"
    sha256 arm64_linux:       "58ffd88667d41052d6ee88d40abdf08d78e33ef529454d7f7cd0bb7a421e3fb2"
    sha256 x86_64_linux:      "f3f305a3916a841d50df9d05d0367e1871f96d2cc2f3f2358b4e57911e342a49"
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

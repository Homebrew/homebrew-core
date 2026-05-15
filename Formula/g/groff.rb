class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftpmirror.gnu.org/gnu/groff/groff-1.24.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/groff/groff-1.24.1.tar.gz"
  sha256 "74e2819795b6aff431aeac983d63a9c8968eeaba2a2eba7df8ba4c7b41e7cfd8"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "c3e55a14145a5904cba3e5bed3417e66b23cc9808736ca043936813308957c9c"
    sha256 arm64_sequoia: "dbe1f8e04914c8a8f104261c479c364f780bbd5dce61750f84efa370a10346a7"
    sha256 arm64_sonoma:  "d52f2237fcf48eac61c290145bd5fff960683b63a9ba4aca5aff899e49803dca"
    sha256 sonoma:        "9fc655ebe0eb1d7ac14ec84f57b677cce6252a4300e90d4e587743822597f7a8"
    sha256 arm64_linux:   "0f31f48d9b8fe7b0f052ce4f1713acbfe60ea209ed81c8b695bf39b31be2186c"
    sha256 x86_64_linux:  "98cc5e858d9adab22a55d1f833df55332354a0a2826212b584c873c527a55d37"
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

  def install
    # Local config needs to survive upgrades
    inreplace "Makefile.in" do |s|
      s.change_make_var! "localfontdir", "@sysconfdir@/groff/site-font"
      s.change_make_var! "localtmacdir", "@sysconfdir@/groff/site-tmac"
    end
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

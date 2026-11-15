class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/releases/download/v1.7.6/hunspell-1.7.6.tar.gz"
  sha256 "9c650ace31d4d8cc1da925a9507c3de1d50f1a54857af2f72429f517d5d53467"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "758f13e3e0cc168aec0e5d6145bd49607333a623cdf8c044a7794a4d153a9d66"
    sha256 cellar: :any, arm64_tahoe:       "4d78ed9081b45b43e45abc361025acdf66eaa57b74825bf05a40196f0f145e08"
    sha256 cellar: :any, arm64_sequoia:     "7fc71825c85bea935f4d3a365159543c40370c6211d7e5bb861a5de6511b1876"
    sha256 cellar: :any, arm64_linux:       "6a78313bef94624260679982838a00603b681217dea27dd98e3eff4ae393121d"
    sha256 cellar: :any, x86_64_linux:      "c953719ff9347151f38d3374bec68646700e5526e0ef1a6350a9f48079312235"
  end

  depends_on "gettext" => :build
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "coreutils" => :build # for timeout in gh646.test
    depends_on "gettext"
  end

  conflicts_with "freeling", because: "both install 'analyze' binary"

  skip_clean "share/hunspell"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-ui",
                          "--with-readline",
                          *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"

    # Find dictionaries installed by other formulae
    share.install_symlink HOMEBREW_PREFIX/"share/hunspell"
  end

  def caveats
    <<~EOS
      Dictionary files (*.aff and *.dic) should be placed in
      ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
      provides no dictionaries for Hunspell, but you can download
      compatible dictionaries from other sources, such as
      https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ .
    EOS
  end

  test do
    system bin/"hunspell", "--help"
  end
end

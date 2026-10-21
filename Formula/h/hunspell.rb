class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/releases/download/v1.7.5/hunspell-1.7.5.tar.gz"
  sha256 "2e559f0c2a592ba48e421477f58e9bf7e01062277a4a7821afb52fc9401010ae"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6392b443edd890774960ff3d5186e3aaf8dace6233346f1223de7a50bc4238fd"
    sha256 cellar: :any, arm64_tahoe:       "05b22bd827bc59b91f6c976e0e3621399474bd220f39b39b1e30b5f59d8c65c8"
    sha256 cellar: :any, arm64_sequoia:     "a3d2964292b7f77eb11ed6e67a1c2ac092a1268454da7befbc592793fc52f46e"
    sha256 cellar: :any, arm64_linux:       "fa741149c48e7ab6809b4f2344a5b2ac379fa9d32a3d85750fc201d9f6077035"
    sha256 cellar: :any, x86_64_linux:      "6b5eec2c32d6b05051b8f7ca228d20e48f908ecae3e4a0216eb79432bdefb4ed"
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

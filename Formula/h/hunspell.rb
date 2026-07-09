class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/releases/download/v1.7.3/hunspell-1.7.3.tar.gz"
  sha256 "433274dac0619cb00c2e18b43a3dd3a9d50da5b5613fa9b5c21781e35dd76bc1"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "503e2e2d4928cbe8a5423b5ec26025fe60f31bdeecb6e9769562a169d4de9073"
    sha256 cellar: :any,                 arm64_sequoia: "3451e2496f485ce24b516a73ede197f309566310c9bc3bb5ace06990097af14d"
    sha256 cellar: :any,                 arm64_sonoma:  "5bc2814195ba15c75ba9ff3d133cf67c2e9274a8ddb5d4ca239acae77a354a8f"
    sha256 cellar: :any,                 sonoma:        "f9e25acf39a97417f787b787f8c871484a3e97ae21941f4680fff26c5984dc27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90da5726acbdd84fe613c115e9e2ba452e5cd662e635f3dfee5a2fc1bc052e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d9ba5107a1726e8e2efe5273fa8332865fad6e5d6074db95f9d62fd01ca566"
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

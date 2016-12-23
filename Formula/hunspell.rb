class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.5.4.tar.gz"
  sha256 "852c01a2e3b87eb1f2adb5261466608ba79f1f950202e18a2a1735de5098fc59"

  bottle do
    sha256 "048a1986ce8f9b45674bcd2e47fe63fb1906f16935631082c7a77ce2fabbf0dd" => :sierra
    sha256 "abd598a5cdebc6f98d19f2e93df444cbc3defe8816ba9261f2fa1058efa591c3" => :el_capitan
    sha256 "c056793bd40e4718fdafa022d005cecb73a498234dd98043f5441d345d54748c" => :yosemite
  end

  depends_on "readline"

  conflicts_with "freeling", :because => "both install 'analyze' binary"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui",
                          "--with-readline"
    system "make"
    system "make", "install"

    pkgshare.install "tests"
  end

  def caveats; <<-EOS.undent
    Dictionary files (*.aff and *.dic) should be placed in
    ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
    provides no dictionaries for Hunspell, but you can download
    compatible dictionaries from other sources, such as
    https://wiki.openoffice.org/wiki/Dictionaries .
    EOS
  end

  test do
    cp_r "#{pkgshare}/tests/.", testpath
    system "./test.sh"
  end
end

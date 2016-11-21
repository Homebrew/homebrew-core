class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.5.0.tar.gz"
  sha256 "b74f2df1aafdbc1f0941d721d7895da4b27b85bba7a4c699a9209477cbbf1f59"

  bottle do
    sha256 "aeeaee8976ad0fd2bdc64bc8b65e4ba41192f15f49483773f8b4450e0e7a0bc2" => :sierra
    sha256 "5c928b33e1cfc274802e3c9e82e296614aae45a33968bfb7d97298e6daa3ee3d" => :el_capitan
    sha256 "208db20141432f55079960cd603a9c233175c9278aedcd2c7582fb77d5cf50ab" => :yosemite
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

class Nuspell < Formula
  desc "Spell checker"
  homepage "https://nuspell.github.io"
  url "https://github.com/nuspell/nuspell/archive/v3.0.0.tar.gz"
  sha256 "9ce86d5463723cc7dceba9d1dd046e1022ed5e3004ac6d12f2daaf5b090a6066"

  depends_on "catch2" => :build
  depends_on "cmake" => :build
  depends_on "p7zip" => :build
  depends_on "boost"
  depends_on :macos => [:catalina, :high_sierra, :dunno]
  uses_from_macos "ruby" => :build
  uses_from_macos "icu4c"

  resource "test_dictionary" do
    url "http.us.debian.org/debian/pool/main/s/scowl/hunspell-en-us_2018.04.16-1_all.deb"
    sha256 "d1964cff134a5774664737c9d585701a86c2191079019707f1293a4c6d8f93f3"
  end

  resource "test_wordlist" do
    url "http.us.debian.org/debian/pool/main/s/scowl/wamerican-small_2018.04.16-1_all.deb"
    sha256 "b06dc81ec85e3ef5fe00ccc95ad9e96b38f3b77800049ea366cfd6376eda3b37"
  end

  def install
    mkdir "build" do
      ENV["GEM_HOME"] = buildpath/"gem_home"
      system "gem", "install", "ronn"
      ENV.prepend_path "PATH", buildpath/"gem_home/bin"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  def caveats; <<~EOS
    Dictionary files (*.aff and *.dic) should be placed in
    ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
    provides no dictionaries for Nuspell, but you can download
    compatible Hunspell dictionaries from other sources, such as
    https://wiki.documentfoundation.org/Language_support_of_LibreOffice .
  EOS
  end

  test do
    testpath.install resource("test_dictionary")
    system "7z", "x", "-aoa", "hunspell-en-us_2018.04.16-1_all.deb"
    system "tar", "xf", "data.tar"
    testpath.install resource("test_wordlist")
    system "7z", "x", "-aoa", "wamerican-small_2018.04.16-1_all.deb"
    system "tar", "xf", "data.tar"
    assert(pipe_output("#{bin}/nuspell -d usr/share/hunspell/en_US usr/share/dict/american-english-small | grep '^*'").size > 45000)
  end
end

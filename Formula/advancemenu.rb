class Advancemenu < Formula
  desc "Frontend for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/menu-readme.html"
  url "https://github.com/amadvance/advancemame/releases/download/v3.9/advancemame-3.9.tar.gz"
  sha256 "3e4628e1577e70a1dbe104f17b1b746745b8eda80837f53fbf7b091c88be8c2b"
  license "GPL-2.0"

  livecheck do
    formula "advancemame"
  end

  bottle do
    sha256 arm64_monterey: "588f863accb297d42af40738e95f307bfbc9212579e626db85d56f31e99b4fae"
    sha256 arm64_big_sur:  "28169ad5c0b9efda64ff4b27e5306df4ba1239937d30403dc569076e8f692010"
    sha256 monterey:       "21d3ffc21aa458c479b338214d623ef2c49a4f42d93099712c5ac916a312aaf3"
    sha256 big_sur:        "81fba884c95faf6fbe13f1dfa128e6875bb3ec7e9743ae70830b2b086863df10"
    sha256 catalina:       "07f9a82231936429257190078d28ec7313b39dfe9ecf3ed9e82b15fbe1615366"
    sha256 mojave:         "36ebf0c6727172fa909b933f801986e483892d5cb10c0a2fb27314880d906bd1"
    sha256 high_sierra:    "fda952fe67d2c39e57d621b6a1392493a95c8ef62f510f63534f962a97252d26"
    sha256 x86_64_linux:   "d8d35e7b682a4d7d5482f242c259d96cfa1cdd87839ce645fbe27c2e4bf97d25"
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "advancemame", because: "both install `advmenu` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}"
  end

  test do
    assert_match "Creating AdvanceMENU standard configuration file", shell_output("#{bin}/advmenu --default 2>&1")
  end
end

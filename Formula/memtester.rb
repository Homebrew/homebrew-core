class Memtester < Formula
  desc "Utility for testing the memory subsystem"
  homepage "http://pyropus.ca/software/memtester/"
  url "http://pyropus.ca/software/memtester/old-versions/memtester-4.3.0.tar.gz"
  sha256 "f9dfe2fd737c38fad6535bbab327da9a21f7ce4ea6f18c7b3339adef6bf5fd88"

  bottle do
    cellar :any_skip_relocation
    sha256 "03b5970aafd201b0959c2ea339a1aa0cc97895e63707f3a441a5c9e3af8e9ace" => :mojave
    sha256 "4c4e1dc949d00a6cd7728c5cc8502c81e2f7fb4bb6859bc3f87f6835928cbc70" => :high_sierra
    sha256 "46f00de9e84e9c3b57533c7b16ef6410add54f13bc9af39a39dcce37d4b78751" => :sierra
    sha256 "e9acbfc46d698da87473227fe344e9999642212289f8365dd4485bc52ce55238" => :el_capitan
    sha256 "fc38d748b19b83c69547ab95bae6adce7009d14b6b21668e20417e7596691c6e" => :yosemite
    sha256 "e2690d42f2744e37e9f0e119736653a92d0d1be2d10aed7ebc7364dad0eeb640" => :mavericks
    sha256 "41a55e47f94006bd7b8a1876b3788811b98d383738dd7153f9c1f1e527322cec" => :mountain_lion
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALLPATH", prefix
      s.gsub! "man/man8", "share/man/man8"
    end
    inreplace "conf-ld", " -s", ""
    system "make", "install"
  end

  test do
    system bin/"memtester", "1", "1"
  end
end

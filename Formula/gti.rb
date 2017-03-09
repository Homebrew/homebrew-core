class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "http://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.5.1.tar.gz"
  sha256 "7638018a174d2cf160224411a95758d23fa5298238d7764b4c75ce3aea16b3fc"

  head "https://github.com/rwos/gti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2732ad123d6d1e211436eb7f931295ef11f5ec6f1803e0e067468cd813f82987" => :sierra
    sha256 "a75e3be5cf27be8fa25d03d1a906ca0156132db5b1f723400a33ddd217e86b0a" => :el_capitan
    sha256 "e9cc0e8d36c874763e989851f8ee859c04e6e0aee8f0a07421c61843a85d6e9b" => :yosemite
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end

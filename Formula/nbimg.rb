class Nbimg < Formula
  desc "Smartphone boot splash screen converter for Android and winCE"
  homepage "https://github.com/poliva/nbimg"
  url "https://github.com/poliva/nbimg/archive/v1.2.1.tar.gz"
  sha256 "f72846656bb8371564c245ab34550063bd5ca357fe8a22a34b82b93b7e277680"

  bottle do
    cellar :any_skip_relocation
    sha256 "75fd1505a68d1c499ddcf73e912947910659d9bd127c208cafeb3e8899664fbd" => :sierra
    sha256 "402904e3588fe5a8ae00d7131fe29821880f31a8ec19fb89e70a79f76e067452" => :el_capitan
    sha256 "7e5f47c47238a5e6b0abca121880c72e78e29d0638924afa75ed999286dc934b" => :yosemite
    sha256 "5389c76ef785f2d7d7ce695dc5b9a1bbecf3dd8eb3fcc8646a28a8b52dfa6a96" => :mavericks
  end

  def install
    inreplace "Makefile", "all: nbimg win32", "all: nbimg"
    system "make", "prefix=#{prefix}",
                   "bindir=#{bin}",
                   "docdir=#{doc}",
                   "mandir=#{man}",
                   "install"
  end

  test do
    curl "https://gist.githubusercontent.com/staticfloat/8253400/raw/41aa4aca5f1aa0a82c85c126967677f830fe98ee/tiny.bmp", "-O"
    system "#{bin}/nbimg", "-Ftiny.bmp"
  end
end

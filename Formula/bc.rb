class Bc < Formula
  desc "arbitrary precision numeric processing language"
  homepage "https://www.gnu.org/software/bc/"
  url "https://ftpmirror.gnu.org/bc/bc-1.07.tar.gz"
  mirror "https://ftp.gnu.org/gnu/bc/bc-1.07.tar.gz"
  sha256 "55cf1fc33a728d7c3d386cc7b0cb556eb5bacf8e0cb5a3fcca7f109fc61205ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0a016b5e05899f1d049334d594f2b2905924175b136d37bc30e87918f3925d1" => :sierra
    sha256 "95aa8d2b198101d25dbecb8d6c2f5c2560c3432e0b00862ecd376abfa7031e39" => :el_capitan
    sha256 "7baaf21d228004af273c5c0b88d4372c8047f2833e507397554e5382f88d83de" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bc", "--version"
    assert_match "2", pipe_output("#{bin}/bc", "1+1\n")
  end
end

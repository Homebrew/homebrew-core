class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.1.3/onig-6.1.3.tar.gz"
  sha256 "480c850cd7c7f2fcaad0942b4a488e2af01fbb8e65375d34908f558b432725cf"

  bottle do
    cellar :any
    sha256 "7ecb3f890a754b476381918973a29951f12e121529ff01b35a054399f057b7c7" => :sierra
    sha256 "c810b2ed83f23f55490441468dde02f81819ed78ccc811ea92ae0750c6bc3a8b" => :el_capitan
    sha256 "75a99e7c082a25999ea8c58c04b49b9306c2ef539eb98e93a60a8f092b573c0f" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end

class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "http://editorconfig.org"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.2.tar.gz"
  sha256 "8a63ae63d3a2f2a202acbd94a6cbe3fa4450c2658e33e922683af33c48a9115d"
  head "https://github.com/editorconfig/editorconfig-core-c.git"

  bottle do
    cellar :any
    sha256 "a6e36c628eaf08d88b65d911c25631e977431ee3b96cb6c4a1d41f95e89a584f" => :high_sierra
    sha256 "899680660a3fdf000c8356e1b9d6a161ce2cbd5fabcabc430f7272919929d935" => :sierra
    sha256 "654a00e1df65376e6aa1374f57fceb651757f00ab08aacb8d077e7343230bffa" => :el_capitan
    sha256 "0a9021863dabaf24a464bc98d1cee290f7324a175b0bd98138d364251b78f887" => :yosemite
    sha256 "34d07fd7086716d9b0e4b078b6f45c95aa7575a1bd56acf8730a6fb69d1750e9" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pcre"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end

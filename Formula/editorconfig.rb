class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "http://editorconfig.org"
  url "https://downloads.sourceforge.net/project/editorconfig/EditorConfig-C-Core/0.12.1/source/editorconfig-core-c-0.12.1.tar.gz"
  sha256 "aa9cd57382c883f1be7b6c3470094317e4d3e64175a376ea49326987055153b8"
  head "https://github.com/editorconfig/editorconfig-core-c.git"

  bottle do
    cellar :any
    sha256 "899680660a3fdf000c8356e1b9d6a161ce2cbd5fabcabc430f7272919929d935" => :sierra
    sha256 "654a00e1df65376e6aa1374f57fceb651757f00ab08aacb8d077e7343230bffa" => :el_capitan
    sha256 "0a9021863dabaf24a464bc98d1cee290f7324a175b0bd98138d364251b78f887" => :yosemite
    sha256 "34d07fd7086716d9b0e4b078b6f45c95aa7575a1bd56acf8730a6fb69d1750e9" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "pcre"

  def install
    ENV.universal_binary if build.universal?

    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end

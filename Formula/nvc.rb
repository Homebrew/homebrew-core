class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.2.0/nvc-1.2.tar.gz"
  version "1.2.0"
  sha256 "9cd31758b0b5cc924bda1ef87d84a78deaa2376f0664c3c87b7045e669d02b52"

  bottle do
    sha256 "8e6b72d2a0a7502387bbe37b4b2bf93025cb88cbe705204d10eb8c6ce73718b5" => :sierra
    sha256 "45fd2562cc085317a9c7b838d48421603efaac1ee46c45dfb6fc0b7eb5c0c51f" => :el_capitan
    sha256 "77392d16a838e2d28b8b50221a356b8f4899a60626d4163180eee1603f225084" => :yosemite
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "llvm" => :build
  depends_on "check" => :build

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        :revision => "c112c17f098f13719784df90c277683051b61d05"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./tools/fetch-ieee.sh"
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end

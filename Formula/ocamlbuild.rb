class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.9.3.tar.gz"
  sha256 "32e4824906888c61244909eab0d2c22d31f18fc9579873a070a4cf7947c2c0a9"
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "20b7271d13155a3be2da5994af1165496874a9e75782792f155cf3339998516d" => :sierra
    sha256 "7907c94fd24eaace12b0d2d5ec3a5e852694fa6ed13b14c82144dd86d9c27b42" => :el_capitan
    sha256 "53e1cab494063e24949e0b89b94f9ebc2b59dd0af38ef1fb3a12eddad6c79821" => :yosemite
  end

  depends_on "ocaml"

  def install
    system "make", "configure", "OCAMLBUILD_BINDIR=#{bin}", "OCAMLBUILD_LIBDIR=#{lib}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocamlbuild --version")
  end
end

class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.14.0.tar.gz"
  sha256 "87b29ce96958096c0a1a8eeafeb6268077b2d11e1bf2b3de0f5ebc9cf8d42e78"
  revision 1
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "4a735f41188227e15df37568e7ecda33e86f409df0a98ad4b7f89f23b560a072" => :catalina
    sha256 "c7c277ed26f4b571d6e03b19e12c67eb09aac6ae3923d30a41db19f95a47aa6c" => :mojave
    sha256 "3f5115d2af6cd6579f025f9caef26407de11307aea64cefed776cc41a0a64edc" => :high_sierra
    sha256 "2ef35dd67ec4c9b4ca26a6ffd3b182e596e50dd83125be4f59b171768af2456d" => :sierra
  end

  depends_on "ocaml"

  def install
    system "make", "configure", "OCAMLBUILD_BINDIR=#{bin}", "OCAMLBUILD_LIBDIR=#{lib}", "OCAMLBUILD_MANDIR=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocamlbuild --version")
  end
end

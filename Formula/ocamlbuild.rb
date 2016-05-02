class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.9.2.tar.gz"
  sha256 "257a3961da1aa47deb3de8da238ebe1daf13a73efef2228f97a064a90f91c6bc"
  head "https://github.com/ocaml/ocamlbuild.git"

  depends_on "ocaml"

  def install
    system "make", "configure", "OCAMLBUILD_BINDIR=#{bin}", "OCAMLBUILD_LIBDIR=#{lib}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "ocamlbuild 0.9.2\n", shell_output("#{bin}/ocamlbuild --version")
  end
end

class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.11.0.tar.gz"
  sha256 "1717edc841c9b98072e410f1b0bc8b84444b4b35ed3b4949ce2bec17c60103ee"
  revision 1
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "c0967a4ad6e92d53941db22065fcf83ea6e1f1b5d02ea9d3533cebed5ab88686" => :sierra
    sha256 "21fd3297dd1fd9fa0562b441752050d2736faa48a71ce7196cd918da91b81b5e" => :el_capitan
    sha256 "3dea9c0a9dc05e5f82d88b29cecfccb2943e6cd4912ac2021b9f0ee42d5521fb" => :yosemite
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

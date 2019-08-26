class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.14.0.tar.gz"
  sha256 "87b29ce96958096c0a1a8eeafeb6268077b2d11e1bf2b3de0f5ebc9cf8d42e78"
  revision 1
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "5bc4b5c08dc6bb9b5ed2fedff2de70870ca2400ccaf1002ac8919ad26181a4ee" => :mojave
    sha256 "0b9fe3df0844b3c7f276e595b75b609611e55be4efa080dc2be10586630dea67" => :high_sierra
    sha256 "78f4e83ddb5c5727047f2ed027706c70a76ff16004e24a4c35efda6239175a99" => :sierra
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

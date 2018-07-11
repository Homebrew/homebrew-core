class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.12.0.tar.gz"
  sha256 "d9de56aa961f585896844b24c6f7695a9e7ad9d00263fdfe50a17f38b13b9ce1"
  revision 2
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "15cfc6410c77840c1c30a97fc9e26b4e8a29e9cf90f8115afbe930462f1f993f" => :high_sierra
    sha256 "6288764b2ba43101a41bae0c53ed43200a66eb625c2df18ad630cb1dda968a88" => :sierra
    sha256 "d9786c774c898be269675374f4a6fa079e5d81b07636572f8220fce201762937" => :el_capitan
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

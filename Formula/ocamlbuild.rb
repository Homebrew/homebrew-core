class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.11.0.tar.gz"
  sha256 "1717edc841c9b98072e410f1b0bc8b84444b4b35ed3b4949ce2bec17c60103ee"
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "db18212dbf85bca4e50400ab75d5ba45fffbb924dcf842fe5a5b7b7cbc040553" => :sierra
    sha256 "094d83c43ad3f010b485e255e4018e8d2c270e02ff3c0f261bbab04d8297626a" => :el_capitan
    sha256 "43b9081e69d0432f4c61d6d618bfa64f93f4ecf47a028d70332e4d092f919d9f" => :yosemite
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

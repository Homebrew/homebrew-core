class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.12.0.tar.gz"
  sha256 "d9de56aa961f585896844b24c6f7695a9e7ad9d00263fdfe50a17f38b13b9ce1"
  revision 2
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "2d115d33a70b07d8e0b0f295f2aad7016c9e8d8e688fac2e355d53399c0006c6" => :high_sierra
    sha256 "d2706d35b3de0eba4be1e82503b31e7c405d69cb7d2fad66bf1a7f2f8fd4bf8d" => :sierra
    sha256 "a6f75d08037ff7bb970aa3e1521e0739e1c10df8096bfa6558ed938404d337e9" => :el_capitan
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

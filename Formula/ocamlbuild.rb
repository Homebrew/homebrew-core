class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.11.0.tar.gz"
  sha256 "1717edc841c9b98072e410f1b0bc8b84444b4b35ed3b4949ce2bec17c60103ee"
  revision 2
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "e8438ae3c391e979cb38682cc8db1d5cb4cbd228b8332255e39c7b866e7a01da" => :sierra
    sha256 "c8dc260e66ddfdc78d6844320be9a7c2f8e191eb8fc7421ad5bf6e5482e7570b" => :el_capitan
    sha256 "498e4af06474baa080371eabf1b83b4608aa376e834f38b3291093c6d29ccca6" => :yosemite
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

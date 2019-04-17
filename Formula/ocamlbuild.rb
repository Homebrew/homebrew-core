class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.14.0.tar.gz"
  sha256 "87b29ce96958096c0a1a8eeafeb6268077b2d11e1bf2b3de0f5ebc9cf8d42e78"
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "18d759416e00773ea4e119c1d72e1ba358e3f3c8518b6ea2c6a7952aff07bd3c" => :mojave
    sha256 "71b333619a1c0929f2fce88878df5d73de753e4306de2b123d2f028f2a63a845" => :high_sierra
    sha256 "65ab796e7fc6174ad45413cf6c9a32e776b3d24f9aef9295b3b14008c4b9a57d" => :sierra
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

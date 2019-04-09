class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.13.1.tar.gz"
  sha256 "79839544bcaebc8f9f0d73d029e2b67e2c898bba046c559ea53de81ea763408c"
  revision 1
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

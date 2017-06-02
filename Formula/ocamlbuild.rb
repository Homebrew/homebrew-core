class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.11.0.tar.gz"
  sha256 "1717edc841c9b98072e410f1b0bc8b84444b4b35ed3b4949ce2bec17c60103ee"
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "4d0f363b71bc36cb80150e751d932fad7dc382806f1ea066f54e13072c4d9611" => :sierra
    sha256 "8dd4e27320e0a3cf3ae81c49a2bd9d3521bd85cd0c4e0aebc1d52789344ff350" => :el_capitan
    sha256 "e3d1ce11e94eb7207bae02a447ce69a22567a708457f1d2dc36beb81769de305" => :yosemite
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

class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.9.2.tar.gz"
  sha256 "257a3961da1aa47deb3de8da238ebe1daf13a73efef2228f97a064a90f91c6bc"
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "fdd70a95ba781a983589909b5a082ee6e472cee937f5f5df6fed52caea67317b" => :sierra
    sha256 "04242e3fb56f3882605504c44ef850008c53839d4e0f742ff32ae306dd98c694" => :el_capitan
    sha256 "d5d4c80d69a1bf90984af137ca7c1facf6e8744d3a938e7e25b4a24bc0d3a824" => :yosemite
    sha256 "13b18cd85715e360b482fd011cb94e4132580e4ef7604b67057266a6331691b9" => :mavericks
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

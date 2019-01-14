class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.13.1.tar.gz"
  sha256 "79839544bcaebc8f9f0d73d029e2b67e2c898bba046c559ea53de81ea763408c"
  head "https://github.com/ocaml/ocamlbuild.git"

  bottle do
    sha256 "fb6fb5e2d678895b9a9e5422821906e6692fbcac70e956e11f0ebd0a7a1699e2" => :mojave
    sha256 "2dc60d50657f67cdcac100e7d0d082547b9e27632c8341e5e9b4a6f566484245" => :high_sierra
    sha256 "3eaafd05870d1c6871ef180ba4852bb5952da23074815a4466e8aec909b1a17a" => :sierra
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

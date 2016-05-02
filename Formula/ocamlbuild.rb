class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.9.2.tar.gz"
  sha256 "257a3961da1aa47deb3de8da238ebe1daf13a73efef2228f97a064a90f91c6bc"
  head "https://github.com/ocaml/ocamlbuild.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbfa590ccdfdfee06dbd5a751201bb8e74b469ef2e2b86755225ffb2eb4720da" => :el_capitan
    sha256 "6194932d62c0002c8286e7c7bf3d04272301669d2a036b7f9d717af3b1370ea4" => :yosemite
    sha256 "a791cec5c4ff4cec0bdff1f25ac2b1a6e906b3e9c485bac285d1b527c9caeeaa" => :mavericks
  end

  depends_on "ocaml"

  def install
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "make", "configure", "OCAMLBUILD_BINDIR=#{bin}", "OCAMLBUILD_LIBDIR=#{lib}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "ocamlbuild 0.9.2", `#{bin}/ocamlbuild --version`.strip
  end
end

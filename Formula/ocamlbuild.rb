class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.14.2.tar.gz"
  sha256 "62d2dab6037794c702a83ac584a7066d018cf1645370d1f3d5764c2b458791b1"
  license "LGPL-2.0-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocamlbuild.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "231ebb957bc74819336ca55e48987714dea31d104b4e84db210c78618c91b087"
    sha256 arm64_monterey: "3d47c72ddcd5a6bead87487dd503bd8cf98b015e04c17a5b2b0696bb75ce83de"
    sha256 arm64_big_sur:  "85b92b0677aa8eb69c0d5835eb2c13d4cf188caec95352060bf7e174950f82ea"
    sha256 ventura:        "75d8634b4512010a45bb4972feccd672c11f1e480f13feedc7b1dc5a040a4c65"
    sha256 monterey:       "4b209b5cac1d988448bd636f92af9d136d789ba0fdf94c92ac691b42294aa987"
    sha256 big_sur:        "7b3e3b42d3183983c581948a3cd125179da47bc000edf3c0fe143cad820589ec"
    sha256 catalina:       "ad29ad617242569e40fa04743c82fffd31e7f095d78e940d022d7077de1bc0fe"
    sha256 x86_64_linux:   "c6dd0b3abbbeab25bfd412f2aaf4a3683b04eb6050c49ccec5d36b99959e20a1"
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

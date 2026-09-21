class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/refs/tags/0.16.1.tar.gz"
  sha256 "2ba6857f2991b7f69368e8db818b163d31cf5a367f15f5953bf8f01a77b3d4fc"
  license "LGPL-2.0-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 2
  head "https://github.com/ocaml/ocamlbuild.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "00c40f3ff05ff224beddef09dd5bfe2052b8473cdad244f3af894250992acdcf"
    sha256 arm64_tahoe:       "8b8baa86b4c4fd8d800937c3f82566a65dcaca3c2c03c382f9c74e089c7704d4"
    sha256 arm64_sequoia:     "b61d6af332d1e8d087cae5eed2b5d5fbe8c41dd0a18f99a4fd22f1376fa70623"
    sha256 arm64_linux:       "36c2e39997ef8991ab31691ac6007840628b587422c7792bcd71b5f53230d3d5"
    sha256 x86_64_linux:      "109e4856e2c458d99166e0462dd7e8456d46cc554759d08405da38b1f75a17ac"
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

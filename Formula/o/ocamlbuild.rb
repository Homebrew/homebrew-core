class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/refs/tags/0.14.3.tar.gz"
  sha256 "ce151bfd2141abc6ee0b3f25ba609e989ff564a48bf795d6fa7138a4db0fc2e1"
  license "LGPL-2.0-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocamlbuild.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "c13da5fb5fd612f38afbe8752675c5db924f8d9f8ca0a2637d1102dfed4aa95c"
    sha256 arm64_ventura:  "e979c1138dcac206a36fc1d57048db287be87f52dd2417979b2bafe043e401fe"
    sha256 arm64_monterey: "860719e69f642a99318725e98e2584dbdd41237b9ee9777994d1807c1cf14ba3"
    sha256 sonoma:         "ae7a45bbd27711f69b3e3fc2c492af7a976cb21a75d068f4d6d4f04a779995ae"
    sha256 ventura:        "e8406774df5ae5de8177e470debad1fbd6e17f048bf13a95a67e81f4fcf226e3"
    sha256 monterey:       "5ec51866b2df0e5c9cf040e9f9c9c0b54789a25020f653ae20c934dd3bf43144"
    sha256 x86_64_linux:   "60f2e3f0593eb466aa9f96fadb5684c54b581319a353fc5b98f0df40dbb37b4b"
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

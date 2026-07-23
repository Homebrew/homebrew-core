class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/refs/tags/0.16.1.tar.gz"
  sha256 "2ba6857f2991b7f69368e8db818b163d31cf5a367f15f5953bf8f01a77b3d4fc"
  license "LGPL-2.0-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1
  head "https://github.com/ocaml/ocamlbuild.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "98c97d371f4dc582d8cb07b6d394ceb02342d5d5307ecc8841f079e56f3232ed"
    sha256 arm64_sequoia: "0abe1c6af4cc7b3d0fac8f0c06c123a0e79d904fb1a68d2cc96d3d1671419b02"
    sha256 arm64_sonoma:  "78199314624484b9fa96453aa0fdae3413407754cae5be84e4af75d9947dd099"
    sha256 sonoma:        "721a09f2dfd087be39aef7be8b28fd9b868a40af6f1abab8fba129fea4d5fe67"
    sha256 arm64_linux:   "3447478d3e2c3d5241200eee517fa3abbecb243425e85dbe8d98283257a2ac26"
    sha256 x86_64_linux:  "b588357e78d2c2835cc4b2b89477e3aa0f394b9edd29f08be867cefbd212451f"
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

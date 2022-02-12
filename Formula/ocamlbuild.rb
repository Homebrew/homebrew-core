class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/0.14.1.tar.gz"
  sha256 "4e1279ff0ef80c862eaa5207a77020d741e89ef94f0e4a92a37c4188dbf08256"
  license "LGPL-2.0-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocamlbuild.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "035b9432d6fe955bb53f2d637fb4de478dfdfd03f22e2884032172e37b226dba"
    sha256 arm64_big_sur:  "d1b989fc6305cb608d4b46a0e71827907074b5a2f5b2b8efb08f93383465c184"
    sha256 monterey:       "97ef3918da137ee1845f434695830599924115318246a9e0dd9bee51ab40a042"
    sha256 big_sur:        "fbc736c65d15027c12f07837a920fe7d3ca20f946fc1c3934970020cc315ea9b"
    sha256 catalina:       "87cb5e4accc61bca40db364eb3818143941f2f6aa8215dabcea33e200e138e87"
    sha256 x86_64_linux:   "d9b0cf584bd021f8872bb80b00d1663484b82f2e634d422c8b1854ca75ff4c8d"
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

class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/refs/tags/0.16.1.tar.gz"
  sha256 "2ba6857f2991b7f69368e8db818b163d31cf5a367f15f5953bf8f01a77b3d4fc"
  license "LGPL-2.0-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 3
  compatibility_version 1
  head "https://github.com/ocaml/ocamlbuild.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "5722643be1d3d928c86f2f582bcf95aea02330fb8149d23a12726da276ee7918"
    sha256 arm64_tahoe:       "a2aa01c207e970539ce7f2e9ae047ad76d7ff346cd5ba5e1146ef426973bb982"
    sha256 arm64_sequoia:     "5baf9dc4ff8bd8c48873bfc67dd45ad68d889ef488096c7166fc1d575e9c09af"
    sha256 arm64_linux:       "927b17d05056fc02775cf3799ed31bbf34600a5d94b1e0ecda9d011e28f654f2"
    sha256 x86_64_linux:      "ad8116990ff7f3db73e0480822e1d97aea2178385719d73fb46b37d1f6d7574d"
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

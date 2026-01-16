class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/refs/tags/0.16.1.tar.gz"
  sha256 "2ba6857f2991b7f69368e8db818b163d31cf5a367f15f5953bf8f01a77b3d4fc"
  license "LGPL-2.0-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocamlbuild.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "35ae1a6eeb68c81a591f49b397e21230a1956a22dc6cd0c8d28486c93786a501"
    sha256 arm64_sequoia: "d102e1f07c6ccb751e1923efcd604fb73bbc46bcf4c5a71c9aab572200f62cb8"
    sha256 arm64_sonoma:  "e852cc2b3119c4b0d0cc5fb252d2f637ca0733e59500574ce07998bf72bbce35"
    sha256 arm64_ventura: "c882d5db337ec2c28a818c1060945ec5a0944e0c4c4596504ad229ff59a17f2f"
    sha256 sonoma:        "7caad9fb8e6256e894222ad3ebf15d9e0a5fb540e461032d5cdf74abafa09dcb"
    sha256 ventura:       "6000d51b9774218b3e11998c0230a140e12b1eb373f124e6c12bf875d80741a8"
    sha256 arm64_linux:   "747624e670b7b2cc2e83a3915c5d9f38d628620c1c98218b8c1da40ae0a44b4f"
    sha256 x86_64_linux:  "664739d1911bb25c0a5375231fe48dd950acfd5e85e1f59154b5de9c01368e08"
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

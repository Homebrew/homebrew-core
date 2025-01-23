class Ocamlbuild < Formula
  desc "Generic build tool for OCaml"
  homepage "https://github.com/ocaml/ocamlbuild"
  url "https://github.com/ocaml/ocamlbuild/archive/refs/tags/0.15.0.tar.gz"
  sha256 "d3f6ee73100b575d4810247d10ed8f53fccef4e90daf0e4a4c5f3e6a3030a9c9"
  license "LGPL-2.0-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocamlbuild.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "2b09cde8d2ceac83a4e552a3482d8ff8616648bf9dab754e15e68fe118a8e32f"
    sha256 arm64_sonoma:   "6e899e4c20ddd7f9b115226a3c7b671cf8e15f20e4855895e9a1b0e4073bc282"
    sha256 arm64_ventura:  "fbc0ef153a1f1b4a8375e41854986e5921641bd1e741aa4a671bf737c7368c0e"
    sha256 arm64_monterey: "a02d14af72c714c28551cf8f18711d618c0976b8876e9224d5af039f22b02b50"
    sha256 sonoma:         "25614a2d620d5dd0fc6bc52a27ca098ab473207e83d26d56dd324fa424401bf1"
    sha256 ventura:        "968f49874ba175416127dafa09a5d566cd17ff6dc5351b77b62489c885767c80"
    sha256 monterey:       "0f2e08f8e9944c28d821149aa74e1551e113b09ebeaf62a51527f5d5d4be21c4"
    sha256 x86_64_linux:   "df513d3b342a6ce1d401c9f2c1224eaf1215131a259499195ed58b1e808fcdef"
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

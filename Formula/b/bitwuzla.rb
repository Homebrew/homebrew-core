class Bitwuzla < Formula
  desc "SMT solver for bit-vectors, floating-points, arrays and uninterpreted functions"
  homepage "https://bitwuzla.github.io"
  url "https://github.com/bitwuzla/bitwuzla/archive/refs/tags/0.11.0.tar.gz"
  sha256 "97d916f5d5fbc79a39ad3d3f95b4871de0fb20d001045289a414826873821d41"
  license "MIT"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "637c0e1eef66bce5642ae6bc89ff8fe2658deb20c2dd4710fafbcfd90222990d"
    sha256 cellar: :any, arm64_golden_gate: "0c16469a4dc86fc28b5072b91eb9f9ff762718cddc6fb4153af3b9e130aabee2"
    sha256 cellar: :any, arm64_tahoe:       "61631969b197f25b9cc4813b60bdcac0dc659618a32a560c43a00c4f99e2c89d"
    sha256 cellar: :any, arm64_sequoia:     "7b29857bb7871d1989e6be275485c5182dcce6094a901fb4afb28a8a52d4c29d"
    sha256 cellar: :any, arm64_linux:       "924dbfe3221257bc2ed250baf0593099524184061728a383b03960b24e62f1c1"
    sha256 cellar: :any, x86_64_linux:      "7fe48e13fb9da2ec69a931c7405ab0424d3bde516addb90644a0af39e07bdedf"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "mpfr"

  deny_network_access!

  def fetch
    system "meson", "subprojects", "download", "cadical", "symfpu"
  end

  def install
    # Not compatible with brew cadical (>= 3)
    args = %w[
      --force-fallback-for=cadical,symfpu
      -Dcadical:default_library=static
      -Ddefault_library=shared
      -Dtesting=disabled
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.btor").write <<~EOS
      (set-logic BV)
      (declare-fun x () (_ BitVec 4))
      (declare-fun y () (_ BitVec 4))
      (assert (= (bvadd x y) (_ bv6 4)))
      (check-sat)
      (get-value (x y))
    EOS
    assert_match "sat", shell_output("#{bin}/bitwuzla test.btor 2>/dev/null", 1)
  end
end

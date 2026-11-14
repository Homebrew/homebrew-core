class Bitwuzla < Formula
  desc "SMT solver for bit-vectors, floating-points, arrays and uninterpreted functions"
  homepage "https://bitwuzla.github.io"
  url "https://github.com/bitwuzla/bitwuzla/archive/refs/tags/0.10.0.tar.gz"
  sha256 "5f4309dfe3e7d716889fa113e7a48a3b4e33efc95348b3cafb036f10e8d17e1d"
  license "MIT"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e957fdaef1f997d0ff3e4fe8e42375587d93357ea24c42735ef95f1f6b02012a"
    sha256 cellar: :any, arm64_tahoe:       "18b3b97bd771f3dc7fa7396b2368dd35c4d43790af52d3b83e7cb82fcdae90b8"
    sha256 cellar: :any, arm64_sequoia:     "c8b8de29d8fbb8dbc81ce55dff35be8fdad2068a0fb3ebe4622de5166e7e3be2"
    sha256 cellar: :any, arm64_linux:       "376c9474ba7973982cc8969162699d446e290cdb2276d62088314b4f85f4a3f2"
    sha256 cellar: :any, x86_64_linux:      "18711ba903b1ec60a488879052340ce5a323768ce5d6ad91e12b35fbfb92be59"
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

class Bitwuzla < Formula
  desc "SMT solver for bit-vectors, floating-points, arrays and uninterpreted functions"
  homepage "https://bitwuzla.github.io"
  url "https://github.com/bitwuzla/bitwuzla/archive/refs/tags/0.9.0.tar.gz"
  sha256 "e15420eaaef586c0d02d4b46cf3bdf203ba2511147b0decab99a9df9c9f115ca"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1aefec513dad32a1fa2276294090522577a32bb2423fe07574099d972652488b"
    sha256 cellar: :any, arm64_sequoia: "56117956505409a4b853ce4d3feda40a26373bfe3ad615da607dbb6e6d79f0dc"
    sha256 cellar: :any, arm64_sonoma:  "4e5aa34b585af95119fe5e4909efc00abc3cb390dda43d23ba5b81fb2160fb13"
    sha256 cellar: :any, sonoma:        "f11a33d62af85cd1d026e685466c793bafa7e0610e889e8342963aa9d21493e3"
    sha256               arm64_linux:   "8347a56e18adc32eef4d53e6ae3f3e7e046ff9aa592fe380c051471f5f6bc56b"
    sha256               x86_64_linux:  "3de69500d8b2cbc2ee2c85a0a07e4be5aade0bd1b315926d3b83641f620d6c32"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "mpfr"

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

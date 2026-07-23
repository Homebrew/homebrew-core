class Bitwuzla < Formula
  desc "SMT solver for bit-vectors, floating-points, arrays and uninterpreted functions"
  homepage "https://bitwuzla.github.io"
  url "https://github.com/bitwuzla/bitwuzla/archive/refs/tags/0.9.1.tar.gz"
  sha256 "42707f38900a20bb18108e426ba667560d1fd2ccce0d4f75aa60439b546488b4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e41762ff9c458e975a603d629d80a2fc7d16706be2a75bf84bea3da723acd36d"
    sha256 cellar: :any, arm64_sequoia: "6c21172734c5fc4f840f4645001daa0372bb916b7ecf03cf2a71bb5f4b5106be"
    sha256 cellar: :any, arm64_sonoma:  "f0e8fc8e07781e375cbc121c8065964d9d007adcf25770003f1622468ce2e644"
    sha256 cellar: :any, sonoma:        "d2718f108e8027774c108021fb006069a3153b2356e9f2cf16938661891775fb"
    sha256               arm64_linux:   "7e52048ed6be0632426a33eb8bb932a46bcf65c7e79dd0daf3f2b7207836375d"
    sha256               x86_64_linux:  "9a31b954433598ee45f3eb15f04ace680ab97113f44f1ab61c28cb406276a0f5"
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

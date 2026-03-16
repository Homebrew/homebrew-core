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
    sha256 cellar: :any, arm64_tahoe:   "bd4be0f59690b95209e2d40eead07a3da969721e99bd7904ebbd65e2442dc4a9"
    sha256 cellar: :any, arm64_sequoia: "a11c02bc02faee3f438c2a3cc5e248c096b34b58588818ae2e1a6e7ccf260f71"
    sha256 cellar: :any, arm64_sonoma:  "ed4d3c68db7f8c090bb1055d58bb4481d4fd0ccf376cb44a9ac526e656ec1c86"
    sha256 cellar: :any, sonoma:        "d788de04dba4aeced6270c38f3d043ab65c821c4c0af992001847be5843b54b4"
    sha256               arm64_linux:   "70695221d6796ec98c71e6f6d6b9754a78e6a776aa05c608feb72e080cacc261"
    sha256               x86_64_linux:  "073560c6335ecdce5557e77b0c96f8f362f4af25002296da4c949673290f969e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

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

class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.42.1.tar.gz"
  sha256 "5b8cbfdea6cf4de5488467297958876aa0b3a79ed5806f7d0f01a0c396beb4e2"
  license "Apache-2.0"
  head "https://github.com/leanprover-community/lean.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version == "9.9.9" # Omit a problematic version tag

        version
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "58337f99ae7f334d298267e4f0153334d408a72d7640aeb7834d6fc8499ed0ca"
    sha256 cellar: :any,                 arm64_big_sur:  "d8dfeaf7e902829013d0109938b910061349a2d16394e48c714a3a1f4b312717"
    sha256 cellar: :any,                 monterey:       "1e14e749b7b08576bc0dd91f6f6fec6ab97c1c32d79f22a69c5a6b4b41330f95"
    sha256 cellar: :any,                 big_sur:        "d623ba837328fe54810386ce2385aef9d147784bdf71c43fb749e09bf68546a0"
    sha256 cellar: :any,                 catalina:       "e16cb80f3a05541ac1d981ff75a6ade15a601931ed8dfa606076ff2b06ac67a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d8d848d08308e6301a5eb4ae8bf6f7155a0936df27270c6a82ba699737c3cca"
  end

  depends_on "cmake" => :build
  depends_on "coreutils"
  depends_on "gmp"
  depends_on "jemalloc"
  depends_on macos: :mojave

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "elan-init", because: "`lean` and `elan-init` install the same binaries"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -DCMAKE_CXX_FLAGS='-std=c++14'
    ]

    system "cmake", "-S", "src", "-B", "src/build", *args
    system "cmake", "--build", "src/build"
    system "cmake", "--install", "src/build"
  end

  test do
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"leanpkg", "help"
  end
end

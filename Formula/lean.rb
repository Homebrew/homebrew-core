class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.39.0.tar.gz"
  sha256 "8fb54fcf3cf43b47bda09a2941237519e4dfb23d580eec6eba1b394fdbd46494"
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
    sha256 cellar: :any,                 arm64_monterey: "d3eb483d558db990c156d7f9f3d069cc7cf04ecd2ec6d9c67e5e2f5dfb9b74fd"
    sha256 cellar: :any,                 arm64_big_sur:  "a5f77757a93432bcbe33fefe6a248ebfa70c0739837ed4ad777c110a40ffd81e"
    sha256 cellar: :any,                 monterey:       "ea9a5c6309e7ba371ff2508471bb15d456de6406d5c1c229b073e1fb0083e15d"
    sha256 cellar: :any,                 big_sur:        "5ef4a13a741d6d28305131e2783c6fd913f8651b9c14745e393fd32abebc664e"
    sha256 cellar: :any,                 catalina:       "c17817acf1c26f6a4fb3c0b6003327e92f2381648f6a7f6d8538b7ac4b2a73e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6941c67e5140300249e07b33aa2e83ca5cbf09f9e2534ec25a62ef68176b3062"
  end

  depends_on "cmake" => :build
  depends_on "coreutils"
  depends_on "gmp"
  depends_on "jemalloc"
  depends_on macos: :mojave

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

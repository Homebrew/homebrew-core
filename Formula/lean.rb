class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.48.0.tar.gz"
  sha256 "07e42b5b040825b6fc2b320784541e1dcc94d189db1ef9f51573ec3eaec74727"
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
    sha256 cellar: :any,                 arm64_monterey: "9eefc50514742b848881b4e5fd436953b98d9c705fe710c5d432c0c1c15b603e"
    sha256 cellar: :any,                 arm64_big_sur:  "31ab8bac858768b8bc2127137ae33300e2f8b69f57f16cdc69c94de290899f92"
    sha256 cellar: :any,                 monterey:       "4e97855eb0b4acf2771ddec3bc1d9fc9f84930c4c083e465dc278332f5f40dc4"
    sha256 cellar: :any,                 big_sur:        "57f9f6762882c852bd3d50eaf5c0348173ad07266c6eaf0f0f812fcac9edc577"
    sha256 cellar: :any,                 catalina:       "1efb482eeb66cc70a89333220b1177fcfc6e84d3646ab8f28d060ab6fe4477f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "720a99d37d7a0181b4fa8083ea7ff2e14c923faf988d6dae32c488b5300c5fcc"
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

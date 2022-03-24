class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.42.0.tar.gz"
  sha256 "b6f96feb25f55c346daadee4f7277fbd9694d3f3f3507ce8cfd9539a04066680"
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
    sha256 cellar: :any,                 arm64_monterey: "e8e216c5cb0d4256f9ff0aba3bbc1082b5c0561a3faedfce45d8d09b89f4c1aa"
    sha256 cellar: :any,                 arm64_big_sur:  "77e133cf7b5dc915a060463052204692c1574de0ea16db2814cb1e5c91000864"
    sha256 cellar: :any,                 monterey:       "62c1c694df08ff40079650639e0868890a898d172adc45b4d92e5ccd5aef6aff"
    sha256 cellar: :any,                 big_sur:        "6aba51e50f11072a0f1f5eac281a63712d9a99eecad8f2eb33aa73fb76db451e"
    sha256 cellar: :any,                 catalina:       "b67d23339d7489e3381e67a4c1dc675bb012255bff6075085edb82e11e1fdb06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "055a52d6d18cb5c867ea1317bbf404fc83b6cf2ce71fc49c2b2f7326e03a24b9"
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

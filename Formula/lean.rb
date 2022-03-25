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
    sha256 cellar: :any,                 arm64_monterey: "c7528cc622c695beddb59b49cffe417aab647f2fbe3216027514b39b27c5ebd4"
    sha256 cellar: :any,                 arm64_big_sur:  "15b1458b935b7219af7868f2ba97961d5cdcb4aec47609ad7cf10392f64fef1b"
    sha256 cellar: :any,                 monterey:       "ee9698f5fb7f63b3fd4538281c022c96af9d911b0af79878afab0752c3feb410"
    sha256 cellar: :any,                 big_sur:        "44eee2c8b4120ae87f311783983b942c923e26de73a1edc40810f700cf6b70c7"
    sha256 cellar: :any,                 catalina:       "485728c8d0656c280b0c6caab8d13cbcb5e8c7208e380a3407cfab08dda05f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fd91969a5185066387123698641fa36d0e96f2f81d7a44a410875d3c6d437cf"
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

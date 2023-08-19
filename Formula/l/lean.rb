class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.51.1.tar.gz"
  sha256 "5a4734bf345d6c5ba6eacd2d33d86d9540eea7d008b4ebf8dde126e729fcbcaf"
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
    sha256 cellar: :any,                 arm64_ventura:  "0797fdae3a180bbc24a6add28a8e877b5b9b7146bbcf20f26a4722de25ba89be"
    sha256 cellar: :any,                 arm64_monterey: "0659bcfa8b37c2ca94ca3f82d816537f17ace87a7b3364b7b751d41df288ea25"
    sha256 cellar: :any,                 arm64_big_sur:  "b37a618f61d1cd10bb4f109b8ac307317d08e9ac400acd22ea06eaad0068132b"
    sha256 cellar: :any,                 ventura:        "42d0f2eb124c69b635767855a38494c89862ecb529db3c9d4f9988d248bd823a"
    sha256 cellar: :any,                 monterey:       "b1c4beba495d421d1d193ab0545c0cc35161b1fec2ec306b11ffe464a7bd3c73"
    sha256 cellar: :any,                 big_sur:        "76f5df6bc494f44c1cc90ff21a40a6cc4024221e2e4956177b29982cc4015f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47716dec0f9e482dd8a44694c4916cc86d104dcc65f50f4fc8d81e0f2d366ef6"
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

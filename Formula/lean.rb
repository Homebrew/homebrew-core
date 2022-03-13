class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.41.0.tar.gz"
  sha256 "1147d5cc990ea1d8c3a39df8e895a6401b12fe545dac984206fc024db3650f69"
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
    sha256 cellar: :any,                 arm64_monterey: "be7bd6c36b83ecd997ca27cf6dcbd713bf1ae1f8700a6c6e50b9e1f8115387f9"
    sha256 cellar: :any,                 arm64_big_sur:  "dbec39107d8914a71618b4a91f03b2be85dc6aad3a8da3e4f2dc03700153f035"
    sha256 cellar: :any,                 monterey:       "eac0e5811abfc8c4995bacd88f2e46358579a8226e5c85a72d34d92a4338bb1d"
    sha256 cellar: :any,                 big_sur:        "7bece78a4f567b4af5f46ec0155170fcecd31a7d3d23bef1371ed67f7316caa3"
    sha256 cellar: :any,                 catalina:       "a732155fa6f15f98072b378aca8b20166dfb63c542ad6a47b376a677155851c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15ec98d6deded1d613573606e34f03ebb0e7d51e4043be652f411374ae81c0c"
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

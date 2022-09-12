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
    sha256 cellar: :any,                 arm64_monterey: "3ba91f5f3f351d6c32cf074dc508866aee62da1dcabe307702617742e2dd80b9"
    sha256 cellar: :any,                 arm64_big_sur:  "6fc90d18f4a3d49826c36215d9eb4ef247cc414d244e9a11f6c182358e3ac8b8"
    sha256 cellar: :any,                 monterey:       "80efbc633c6450fbf4e21f937b643bb95e9d1be515886cc24a66905c06d1b68f"
    sha256 cellar: :any,                 big_sur:        "e116b96b17f35261d90f3e3d8855f8dd769ee00278927deb779cc82212f24a17"
    sha256 cellar: :any,                 catalina:       "1077659719dfad667ee9e65f9f8dfbdabcb73a4f5e7ec1ebe39c6524e5f0d431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cbd7e64df4002f668a2c15bb750f3dbd674da307ab1c391ff5da1435ba7f3aa"
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

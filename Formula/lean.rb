class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.45.0.tar.gz"
  sha256 "92d2676e46447a62103dd17b7a5cb17ab7054dc2878be345a846fb03d8e6bcf5"
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
    sha256 cellar: :any,                 arm64_monterey: "a68f8a10beb4a5837a1af236cdc1a255930f1e0dd21577c53844f56ce32d346f"
    sha256 cellar: :any,                 arm64_big_sur:  "84f8ec687078df3e217828ecb980561dd70376a54c509c94f95affeedc85fe4f"
    sha256 cellar: :any,                 monterey:       "d50fa87749b75e86a442239cbbafa1ac699d501db55dde20230382d9874a2a6b"
    sha256 cellar: :any,                 big_sur:        "aa3790e8080f83e3492d74361dbe7a98108ffb4614e0972ebe1d13281819b5de"
    sha256 cellar: :any,                 catalina:       "cf568542137cc15aeb9befa036f2201426c325fc442cba8b673d3b5a348237df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525728c588f57e835c94d3530df5d46ef0daaf3f46539ee18922e4c55d30b283"
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

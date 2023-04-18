class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.50.3.tar.gz"
  sha256 "00316c946de2aa4f1b6655ea8bd92b21ff184afd305891e6803c7631753f5b87"
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
    sha256 cellar: :any,                 arm64_ventura:  "8dbb51ed79cbfa8521ba6827fbcd3a19bc0b0c7a4caf1fc2084c769f0b07d682"
    sha256 cellar: :any,                 arm64_monterey: "52f3fbb2af5e69d02ccccdef798dbc0300ce7a399afafd49ef9ccd4bc657cb4a"
    sha256 cellar: :any,                 arm64_big_sur:  "bb0331dbdcd1de6b8f2d24938ef96658ebd10de90fcb6e084a297994473b8bbc"
    sha256 cellar: :any,                 ventura:        "c085fa626d89dd857de35c19df59ea13d835bc3a595824b1b78bf364b950b24f"
    sha256 cellar: :any,                 monterey:       "bcbceb47384c0e6903a61874d16485dc2a3d5a5a1c684e05a1baae01ed2356e1"
    sha256 cellar: :any,                 big_sur:        "d1076aebc8c7f3c834578c542e4bc01b5e55e327b0363494a2bdf9027cfa17d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8be25df029dfc12cd9f95a2bde42fe0e37e88fd8294adb62a0533356764635c7"
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

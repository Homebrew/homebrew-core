class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.49.0.tar.gz"
  sha256 "c90850921cafc69bf4d8c976d2b65de02abd9b5f46cf8aa91f7c2585ed775c0e"
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
    sha256 cellar: :any,                 arm64_ventura:  "d463cba22651a4e7eaf80adba13fb166c624dec2e2e56d87c3c9d8b7e97e01f2"
    sha256 cellar: :any,                 arm64_monterey: "90ff53692ebe5de03512548147255d8b1cd656f75dbf01553a44e1aafd8e82da"
    sha256 cellar: :any,                 arm64_big_sur:  "8648c3545516d45f24b65353ac015fe72638da758219fb0ab5229fc52ae349de"
    sha256 cellar: :any,                 ventura:        "2510670fb3775c56259a4d2e0dd9bdeb67710b606f453e7cc22b851960995d7c"
    sha256 cellar: :any,                 monterey:       "7f113064021ac6194c048f6c9afaeece7a81e9058367d52a49f7ccfd4e032635"
    sha256 cellar: :any,                 big_sur:        "3575ca53b32ef46960526c21499fabbb45161b45d383df43997d62ef3946cb7f"
    sha256 cellar: :any,                 catalina:       "25107a5c8310039640b0a22f851d0caa153057ddd45a80be2435514ef9a0ac6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a858cfa09551775393370bf3fa3e408ea99f6786718f5ceb358e015a3df053"
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

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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "d0afd57b78f244e7e238b6c9c5e8e2cb9139bd626f254d7841fa1108aa62ebe0"
    sha256 cellar: :any,                 arm64_big_sur:  "42d22be3d5d21532f4abb0e68ab738605cad858faa0d490d21cc5764398b8e2f"
    sha256 cellar: :any,                 monterey:       "db773f3b61ae44d9d40a6f33880c917a9c8bb696789a57e9bd2ec8046ef201b9"
    sha256 cellar: :any,                 big_sur:        "ce9af32ea03cef2cd8f88656c4500e5da674b22ea654a43d334818ae6bfe82a5"
    sha256 cellar: :any,                 catalina:       "c73d8d54f020206e7eaeb0439471091485950906e588ee1055848f6d536aead0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01d00611801cf87a1e16a54ed954243cea3ea3dd500b65f7be7e5d2c883039b"
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

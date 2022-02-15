class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.39.1.tar.gz"
  sha256 "7a4179dbfe90317ad19a7fde76dfd38fb0f2ed24e08208b1ebee6b98b8396063"
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
    sha256 cellar: :any,                 arm64_monterey: "ee80bfa3c711ce9ddb31e48ddc29316e7cc0e53d9192c443f47221760e640b2f"
    sha256 cellar: :any,                 arm64_big_sur:  "6bae3ab4c53145f275dbf121e88f7d53db01edf3ddb8e390d1c767b8740a6a2d"
    sha256 cellar: :any,                 monterey:       "31cb8e3eb8b12c0808b8513ec8856d2118528192fc473ba4e0dcd91fb0f9f2a8"
    sha256 cellar: :any,                 big_sur:        "3bdd15dab0d81a28abd515bf9699db1220fa0e658af4ba6ba797c80d196eac08"
    sha256 cellar: :any,                 catalina:       "029a3b2367fbeca9dd3baa0bd0bb88eb5cfbece6cc45e1c335255adaf33440f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8ba6db0394ecfb7f8a5821f7a2a383c1c5186a4c0811f9326af4506003db560"
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

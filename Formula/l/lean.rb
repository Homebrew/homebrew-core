class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/refs/tags/v3.51.1.tar.gz"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "a5568b994d186b0a5e50a10dcfaa7e7ada0106308a8f80412eea4e71662729cf"
    sha256 cellar: :any,                 arm64_ventura:  "0525ce214174c28a6604f69a8ccf14477dcf311b587572c19729d8b7302dfd8e"
    sha256 cellar: :any,                 arm64_monterey: "fdf55df69720f665834f8b31e8071e0d0802552a265aa0075bbe60676faf7a0a"
    sha256 cellar: :any,                 arm64_big_sur:  "d231fbba7c033640f2f5f912a4e23a92831217d7a374f54836b8075707ab263b"
    sha256 cellar: :any,                 sonoma:         "500529aa863acd0c4d5f1257d391bd496d40cafa6aba87595071d786c38d7f47"
    sha256 cellar: :any,                 ventura:        "2cab4d1b6b3a2386333dce3b836f47e815747fd95d5cd3ce84e1b094be7f8278"
    sha256 cellar: :any,                 monterey:       "418e91f115eda2f2956ec13d4ba57101e55d1cfee8154518db90f5fbbda48344"
    sha256 cellar: :any,                 big_sur:        "e101719fb4712cbe706aa8a32d1335b3b6b5211a2e741eb2fb714f079814b2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9024e8785665fa3529e7a02d4488b49bfd713a0c46a9173224eb84859ffb42"
  end

  # Lean 3 is now at end of life.
  # The `elan-init` formula provides a Lean installation manager
  # which continues to support Lean 3 users, but also provides Lean 4.
  disable! date: "2024-06-28", because: :deprecated_upstream

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

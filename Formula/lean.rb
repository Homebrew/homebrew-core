class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.38.0.tar.gz"
  sha256 "3b6fdfc2847a5553511943c88e166b3c14cafb78fecab33eb5acc89b9c2952a1"
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
    sha256 cellar: :any,                 arm64_monterey: "0372f802742667f07f4b451db61483608adbfeb0a16fb226bdbe3d27ea6da513"
    sha256 cellar: :any,                 arm64_big_sur:  "2e7d5d72c9341c473f6c72edf633b8eecb93e7bed78a8b72139b9d3062f285e7"
    sha256 cellar: :any,                 monterey:       "ab53ddc187f71ed59f14e4e041346f276812c5c9c62b5a210e313fc8d0341107"
    sha256 cellar: :any,                 big_sur:        "8fb3a11e18a2005fe146bd0253634a8b8e980d9e0e12aeda031695697c9a46e7"
    sha256 cellar: :any,                 catalina:       "5a107a325ca89c60e138458e3a3db3e41782eed33ad602341ae26c5a0793a944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49f03064b4af7c9b0e2957dff1a7c737a234ed4d88a5e21c9c719cc10df3bb04"
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

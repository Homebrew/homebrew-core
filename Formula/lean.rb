class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.49.1.tar.gz"
  sha256 "d586d1ec89cfa2dbbd5a7d91d4433b8d75cb42e92ebadd4a4a2c3010ad211610"
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
    sha256 cellar: :any,                 arm64_ventura:  "32e2a4d54d1c85dd63eb2ee2a99a3b6c0bd9ac297185548804672626878aaed8"
    sha256 cellar: :any,                 arm64_monterey: "797b0c9fb80854330144a4a0593bb8779bb5bd098ef39d1665acae0ba134b089"
    sha256 cellar: :any,                 arm64_big_sur:  "9e89d9d4179898bfdc7e99ed2486c197872ecd756e4eb51b5b2d30fcf54cb1a0"
    sha256 cellar: :any,                 ventura:        "7bb12d3a2f6b7c5971d944cf1ccb905669317471df1c808c1fd8d557d0e178ab"
    sha256 cellar: :any,                 monterey:       "29cd1d5d80eb91915a366f1bbafc39574a3fce11e0c830255b6af055e3a69d0b"
    sha256 cellar: :any,                 big_sur:        "fbd1bbe836110b78c60e44612637954043a24427d75cd983cd48ada3e630e601"
    sha256 cellar: :any,                 catalina:       "aee0f2f19db98e20ef39a030b4ebcdcff01433f9d29294efab86bc0da33a843d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf657359b12f4fd90287821cbb638fd07bb856e7f6bd70e291555a49e9e6eb67"
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

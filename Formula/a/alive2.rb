class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  url "https://github.com/AliveToolkit/alive2.git",
      tag:      "v21.0",
      revision: "913e1556032ee70a9ebf147b5a0c7e10086b7490"
  license "MIT"
  revision 1
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8c3935783048daac8c011062c238153f53f64c8e50d85740e4ddbf305e854e5e"
    sha256 cellar: :any,                 arm64_sequoia: "852de8acba9d16303ff13d423c9d0f4402062335644e1bbcff815d8179c82a5b"
    sha256 cellar: :any,                 arm64_sonoma:  "83982b721000e6cd17b97f25d1c587af19da13e09036ca12445bb6b0f000863e"
    sha256 cellar: :any,                 sonoma:        "7746e44ad80366a730364e270921a2c159d40cd743e72d14891e0e253f0d5b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0888016b2365edd46b00dfcfc9cda77dd473d98cc47de8f57dd5ee5cc5d4202d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edf39546561dddd3d45aee2f365e92ede4a60622ccc8e47154d1f4cf0d3fb3f8"
  end

  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "hiredis"
  depends_on "llvm"
  depends_on "z3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1500
    cause "error: reference to local binding 'src_data' declared in enclosing function 'IR::State::copyUBFromBB'"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_LLVM_UTILS=ON", "-DBUILD_TV=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main(void) { return 0; }
    C

    clang = Formula["llvm"].opt_bin/"clang"
    system clang, "-O3", "test.c", "-S", "-emit-llvm",
                  "-fpass-plugin=#{lib/shared_library("tv")}",
                  "-Xclang", "-load",
                  "-Xclang", lib/shared_library("tv")
  end
end

class Alive2 < Formula
  desc "Automatic verification of LLVM optimizations"
  homepage "https://github.com/AliveToolkit/alive2"
  url "https://github.com/AliveToolkit/alive2.git",
      tag:      "v20.0",
      revision: "c0f5434f402ad91714ee0952f686cd0f524920ad"
  license "MIT"
  revision 1
  head "https://github.com/AliveToolkit/alive2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "201651362fc1625236a8e9cd26db20e33bb86cb2073efbe35653d7e3e4952998"
    sha256 cellar: :any,                 arm64_sonoma:  "4efdfa5d4d8ec7771e5bc1126ddf1c1b6a915f69692bfc61f03e1f3fef8919a8"
    sha256 cellar: :any,                 arm64_ventura: "604b2711e55c46430a24767fd371c1c7e7505404edffcc97410dd0df73527c23"
    sha256 cellar: :any,                 sonoma:        "9d3cdde41a86ff42dc2660e8634df0c8eb1240e880750c9517a9a98251a8bda7"
    sha256 cellar: :any,                 ventura:       "9f07846cc60eeff05bc3eaee714f32f69a7506c732018eb20f27692006ee1d23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2a45cad9f8b7ac0fa5daeea1b65c6fda97fc12b9f8546b13b8ca1e6068b2b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79797ee447a5be2dba84697d20a1f1296c4ffcf0975a83c75147a8cd94f36629"
  end

  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "hiredis"
  depends_on "llvm"
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "zlib"

  def install
    # Work around ir/state.cpp:730:40: error: reference to local binding
    # 'src_data' declared in enclosing function 'IR::State::copyUBFromBB'
    ENV.llvm_clang if OS.mac? && MacOS.version <= :ventura

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

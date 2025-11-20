class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "4b39ae895f00b046878d5f312eec11c4b7d38d08b08e9de249a4eef938750229"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "02b162aef7ff29ffb882c721e04343c576f9bc49b6f4b9855f4eabb3c7ef49a3"
    sha256 cellar: :any,                 arm64_sequoia: "d9735069362304a255413ceac888da9a16f24550fc5bc00c7e5b51f4e18a273a"
    sha256 cellar: :any,                 arm64_sonoma:  "e34dbaa9defa0abdda3206a6d3573f01e7189c000164ddd38bdd15cd6c925c5e"
    sha256 cellar: :any,                 sonoma:        "948673e7583c5a65587427d3d395512b62680e7052317a309ab41212eedbf139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa0c7fb22f978f82ae62ad7836e694d824b8a3aa5023288edbaef78ff0fc5430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a44f295e493931b12b56000900bf345cba3616415b6d7007b7829f5b27af39c0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  # Backport fix for "Encountered unsupported BuiltinType kind 104 for type __mfp8"
  patch do
    url "https://github.com/immunant/c2rust/commit/a2c2149dae044629a49e996597ab58eb950072d0.patch?full_index=1"
    sha256 "9ec18885f174526d3b6228c1e584dae942a5418f49089b4c0fc4439aecde7317"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_path_exists testpath/"qsort.c"
  end
end

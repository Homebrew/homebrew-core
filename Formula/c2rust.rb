class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://github.com/immunant/c2rust"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9ed1720672afb503db91b30cec1dedcf878841f57eaea4c7046839890990d8cd"
  license "BSD-3-Clause"

  # Linux bottle removed for GCC 12 migration
  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ed7fd65c5dab2ba23a06bb8eaf26900c6c88001adcf981609807875fcb2421da"
    sha256 cellar: :any,                 arm64_big_sur:  "d47181b738106f95d02e50b5d38b77617b3f7434e2eb3c7d013fb6916917942a"
    sha256 cellar: :any,                 monterey:       "e731c18631ef35b1fbc5a47210b486d6fc09689572e9ed16e99369ae87759086"
    sha256 cellar: :any,                 big_sur:        "5ef83273bd576ccfbc9a8f94a882f6a473e6675030bc770db125bc3432d815e5"
    sha256 cellar: :any,                 catalina:       "fda784d7984de0032064041302d4027aa87046fdba7f54a9e7d11ab4b8ad3570"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_predicate testpath/"qsort.c", :exist?
  end
end

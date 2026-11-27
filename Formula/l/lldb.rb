class Lldb < Formula
  desc "Next generation, high-performance debugger"
  homepage "https://lldb.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.6/llvm-project-23.1.6.src.tar.xz"
  sha256 "d3b86ab29cfb4445a6652e5c2642ccc75e04e38084dde3701d323320f35a31da"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    manifest_sha256 "ef089d14b2c0e6fc2ac83c44e13b587d95d202a96723af787e9a678ab9516e12"
    sha256 arm64_golden_gate: "9b3ca76ffcb19d01246904d4205d4f76168ac8f6b0ee800be3c1e8f410815f12"
    sha256 arm64_tahoe:       "440571f9d7f30ea761f9392d946d293d1261760edbc9a9fa2d4e0225ec2eb6a2"
    sha256 arm64_sequoia:     "4d80273d2060e73158d2326145cc5c06b412739476c1a3e05fbf073ba7bd87fe"
    sha256 arm64_linux:       "94917b9c04d7b5f1a8b9357d6cc6900eaeb9601d377d8fd6fa9afcd73a49654b"
    sha256 x86_64_linux:      "7994f70642cd6001b01a5d4f2c1e90191f0be1982bf471af82c2bc04cab0aae1"
  end

  keg_only :provided_by_macos

  # https://lldb.llvm.org/resources/build.html
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on "llvm"
  depends_on "python@3.15"
  depends_on "xz"
  depends_on "z3" # TODO: remove in LLVM 24
  depends_on "zstd"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    cause "linking fails with undefined references"
  end

  def install
    # Features are set ON/OFF to avoid auto-detection impacting reproducibility.
    # See https://lldb.llvm.org/resources/build.html#optional-dependencies
    llvm_lib = formula_opt_lib(name.sub("lldb", "llvm"))
    args = %W[
      -DLLDB_ENABLE_CURSES=ON
      -DLLDB_ENABLE_LIBEDIT=ON
      -DLLDB_ENABLE_LIBXML2=ON
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_ENABLE_LZMA=ON
      -DLLDB_ENABLE_PYTHON=ON
      -DLLDB_ENABLE_TREESITTER=OFF
      -DLLDB_INCLUDE_TESTS=OFF
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLVM_BUILD_UTILS=ON
      -DLLVM_DIR=#{llvm_lib}/cmake/llvm
      -DLLVM_ENABLE_LTO=ON
    ]

    system "cmake", "-S", "lldb", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Check that lldb can use Python
    lldb_script_interpreter_info = JSON.parse(shell_output("#{bin}/lldb --print-script-interpreter-info"))
    assert_equal "python", lldb_script_interpreter_info["language"]
    python_test_cmd = "import pathlib, sys; print(pathlib.Path(sys.prefix).resolve())"
    assert_match shell_output("#{python3} -c '#{python_test_cmd}'"),
                 pipe_output(bin/"lldb", <<~EOS)
                   script
                   #{python_test_cmd}
                 EOS
  end
end

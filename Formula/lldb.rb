class Lldb < Formula
  desc "Next generation, high-performance debugger"
  homepage "https://lldb.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/lldb-14.0.6.src.tar.xz"
  sha256 "2ac41160b0bdc74bf72d4f9a3702f290f7c09998da6fb73281cc497f4ddbe130"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "llvm"
  depends_on "python@3.10"
  depends_on "six"
  depends_on "xz"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    keg_only "provided_by_macos" # TODO: change to :provided_by_macos after adding to Homebrew/brew
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # LLVM is built with GCC

  def python_executable
    Formula["python@3.10"].opt_bin/"python3"
  end

  # we install the lldb Python module into libexec to prevent users from
  # accidentally importing it with a non-Homebrew Python or a Homebrew Python
  # in a non-default prefix. See https://lldb.llvm.org/resources/caveats.html
  def site_packages
    Language::Python.site_packages(python_executable).delete_prefix("lib/")
  end

  def install
    srcdir = build.head? ? "lldb" : "lldb-#{version}.src"

    # Avoid adding extra relative RPATH on Linux
    inreplace "#{srcdir}/source/API/CMakeLists.txt",
              "set_property(TARGET liblldb APPEND PROPERTY INSTALL_RPATH \"\\$ORIGIN/",
              "#\\0"

    system "cmake", "-S", srcdir, "-B", "build", *std_cmake_args,
                    "-DCLANG_LINK_CLANG_DYLIB=ON",
                    "-DLLVM_LINK_LLVM_DYLIB=ON",
                    "-DLLVM_ENABLE_SPHINX=ON",
                    "-DLLDB_INCLUDE_TESTS=OFF",
                    "-DLLDB_ENABLE_CURSES=ON",
                    "-DLLDB_ENABLE_LIBEDIT=ON",
                    "-DLLDB_ENABLE_LIBXML2=ON",
                    "-DLLDB_ENABLE_LUA=OFF",
                    "-DLLDB_ENABLE_LZMA=ON",
                    "-DLLDB_ENABLE_PYTHON=ON",
                    "-DLLDB_PYTHON_RELATIVE_PATH=libexec/#{site_packages}",
                    "-DLLDB_PYTHON_EXE_RELATIVE_PATH=#{python_executable.relative_path_from(prefix)}",
                    "-DLLDB_USE_SYSTEM_DEBUGSERVER=ON",
                    "-DLLDB_USE_SYSTEM_SIX=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build the lldb manpage using sphinx-doc
    system "cmake", "--build", "build", "--target", "docs-lldb-man"
    man1.install "build/docs/man/lldb.1"
  end

  test do
    with_env(PYTHONPATH: libexec/site_packages) do
      system python_executable, "-c", "import lldb"
    end
  end
end

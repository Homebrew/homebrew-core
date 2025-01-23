class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.4/cmake-3.31.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.31.4.tar.gz"
  sha256 "a6130bfe75f5ba5c73e672e34359f7c0a1931521957e8393a5c2922c8b0f7f25"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "038ad9efc2be6564f870d8faafd1a3871e43da6ea398f9c1fe2ffe7e90831718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "082e2ed3a5ac66054c5f4bc1955250ae95621286863f4cce6fbd4ce860f1b682"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14552df25322c69da795c7d365486510dc7c935b9eac387b52401ca8b9c4ee77"
    sha256 cellar: :any_skip_relocation, sonoma:        "12a29092f879bf8d0c996f74338ecfaa46fba61a8f60188dbef230a6e4ddaefa"
    sha256 cellar: :any_skip_relocation, ventura:       "b8494043df00cee8781f09a386f61f90d567fdba7f9f4a291c73822a84c23018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f16b2f02b1c3fb1429d78deabfca7149d23e5c56fb621fd8175b96e05e21a86d"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # Prevent the formula from breaking on version/revision bumps.
  # Check if possible to remove in 3.32.0
  # https://gitlab.kitware.com/cmake/cmake/-/merge_requests/9978
  patch :DATA

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end

__END__
diff --git a/Source/cmSystemTools.cxx b/Source/cmSystemTools.cxx
index 5ad0439c..161257cf 100644
--- a/Source/cmSystemTools.cxx
+++ b/Source/cmSystemTools.cxx
@@ -2551,7 +2551,7 @@ void cmSystemTools::FindCMakeResources(const char* argv0)
     _NSGetExecutablePath(exe_path, &exe_path_size);
   }
   exe_dir =
-    cmSystemTools::GetFilenamePath(cmSystemTools::GetRealPath(exe_path));
+    cmSystemTools::GetFilenamePath(exe_path);
   if (exe_path != exe_path_local) {
     free(exe_path);
   }
@@ -2572,7 +2572,6 @@ void cmSystemTools::FindCMakeResources(const char* argv0)
   std::string exe;
   if (cmSystemTools::FindProgramPath(argv0, exe, errorMsg)) {
     // remove symlinks
-    exe = cmSystemTools::GetRealPath(exe);
     exe_dir = cmSystemTools::GetFilenamePath(exe);
   } else {
     // ???

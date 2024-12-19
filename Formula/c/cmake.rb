class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.3/cmake-3.31.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.31.3.tar.gz"
  sha256 "fac45bc6d410b49b3113ab866074888d6c9e9dc81a141874446eb239ac38cb87"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "618b65daefae07021dd94c35b65ab67b42e88a2d245691301ab60a338bf40b89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95702f79ebd80bc62aa8f6be88601e99db22100a5d66987ab9081a66e64d0b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c83dabbdec1aee3aa3150ce84bdc8bc83d8e1f54c8380c1c42c665ca86a8de1"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b18ff637539f3c33d27a908b9de15a50d7e33a11c445e1c4043b48f32c7095"
    sha256 cellar: :any_skip_relocation, ventura:       "3035c08f61cc09e7f06c617d667621b0892eb09ac02745755598fcbc60406fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94648640a5dc12d677622b2c680d5de401542e06d9f50a486dcb5b1ebf211a37"
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

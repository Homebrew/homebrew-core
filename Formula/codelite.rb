class Codelite < Formula
  desc "Cross platform C/C++/PHP and Node.js IDE written in C++"
  homepage "https://codelite.org"
  url "https://github.com/eranif/codelite/archive/11.0.tar.gz"
  sha256 "9eb23ea635fc746318a832efd752b08027c11efcd9af7f494f31dbaacdd651a1"

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "wxmac"

  def install
    # Known Issue:
    # If you built `wxmac` with "--with-stl" option, you cannot build this Formula.
    # Because this Formula requires cxx11.

    # https://github.com/eranif/codelite/issues/1284
    # https://github.com/eranif/codelite/pull/1797
    inreplace "CMakeLists.txt", "set(WX_COMPONENTS \"std\")", "set(WX_COMPONENTS \"std aui propgrid ribbon\")"
    inreplace "codelite_terminal/CMakeLists.txt", "wxWidgets REQUIRED", "wxWidgets COMPONENTS std stc REQUIRED"
    mkdir "build-release" do
      system "cmake", "..", "-DCL_PREFIX=#{prefix}", *std_cmake_args
      system "make", "install"
      prefix.install "codelite.app"
    end
  end

  test do
    system "#{opt_prefix}/codelite.app/Contents/MacOS/codelite-clang-format", "--version"
  end
end

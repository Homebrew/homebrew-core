class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/project/podofo/podofo/0.9.8/podofo-0.9.8.tar.gz"
  sha256 "5de607e15f192b8ad90738300759d88dea0f5ccdce3bf00048a0c932bc645154"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "svn://svn.code.sf.net/p/podofo/code/podofo/trunk"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dd25d9bea4a314122b3e1aee20cc2985f9d4435ae84c0ece7ddd74c7ceec2cdd"
    sha256 cellar: :any,                 arm64_big_sur:  "1df7e49da361eece0d33e57eda0463b0f1bb60508afaeb75a4e0a60c4992b1bd"
    sha256 cellar: :any,                 monterey:       "e3d40338c4b76c8f0b25c4fceb5644c75e9ee0a6c8eb59c5e3f9455cc42a592c"
    sha256 cellar: :any,                 big_sur:        "16d8fbe8da7080e80efc0125002fb1df2f37f2e0a77ef5bb854ed203e7f07bd1"
    sha256 cellar: :any,                 catalina:       "da10d1382d4a3ffcd26f399081f2c619c6e7ffa44bdba982f531ba3d4fd53ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c82a5d52d9146cd7ab5ad2113fe23247093c4a6ae2abad6c9461cc13b43f4a7"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON
      -DPODOFO_BUILD_SHARED:BOOL=ON
      -DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2
      -DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/
    ]
    # C++ standard settings may be implemented upstream in which case the below will not be necessary.
    # See https://sourceforge.net/p/podofo/tickets/121/
    args += %w[
      -DCMAKE_CXX_STANDARD=11
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "500 x 800 pts", shell_output("#{bin}/podofopdfinfo test.pdf")
  end
end

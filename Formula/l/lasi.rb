class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.3%20Source/libLASi-1.1.3.tar.gz"
  sha256 "5e5d2306f7d5a275949fb8f15e6d79087371e2a1caa0d8f00585029d1b47ba3b"
  license "GPL-2.0-or-later"
  revision 2
  head "https://svn.code.sf.net/p/lasi/code/trunk"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "b912d8b980908ab389f63632dd5f37dd43689714732f64eb5d581c40bb7d2b59"
    sha256 cellar: :any,                 arm64_sequoia:  "cacfb48c1b73960804bf1471d86942b79e306cbf737242f31456fd41588798c0"
    sha256 cellar: :any,                 arm64_sonoma:   "784a47e3a5a0eba53a4a1ffcc00b0aecddf0b04a588ef2ad10b0ee8d90803c61"
    sha256 cellar: :any,                 arm64_ventura:  "b13ac894940a19c92183c5fad1f5058232af01fb4d6a7c8c1a490d5f289c3fc2"
    sha256 cellar: :any,                 arm64_monterey: "7316df1ac91816fd9ee342a973b4b96dd3e2bb4ce9eb93fedfe96b30a109d8f8"
    sha256 cellar: :any,                 arm64_big_sur:  "f6f4ac7da7af9beba184fff05fd4419335c07710beb3a2e3646afdde31745770"
    sha256 cellar: :any,                 sonoma:         "3ba98494b45476be8d8b75f2b2d2f2e8fe366618b7cc26b2ced89ba5bb5124f8"
    sha256 cellar: :any,                 ventura:        "219654bc604d3071f1cbf7c5b39855af57ecaafe12088bd5e805373098fb2b7f"
    sha256 cellar: :any,                 monterey:       "d70d80fbc43693c3df3b1256ad7779d0cc7a5776cef1502faf9fa4868c1e9fee"
    sha256 cellar: :any,                 big_sur:        "d4d9a1f05e4acef822930f62b4dd5b5f87f815e01523eb41b91df079af35b69b"
    sha256 cellar: :any,                 catalina:       "9c9b3d4df3fef9c27ccc60f51583976cfb7093c5ea345c0dced428e0539b7ede"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "70ef82ea6ebb0ad9deea3e12e5a88db9f24653599a256d0577422b2481f8d498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81717d41a1ac50a3f35199b82877d62fce7abb1da670c98cd2abb762e2a1b8b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "glib"
  depends_on "pango"

  on_macos do
    depends_on "fontconfig"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    # If we build/install examples they result in shim/cellar paths in the
    # installed files.  Instead we don't build them at all.
    inreplace "CMakeLists.txt", "add_subdirectory(examples)", ""

    # std_cmake_args tries to set CMAKE_INSTALL_LIBDIR to a prefix-relative
    # directory, but lasi's cmake scripts don't like that
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=11", *std_cmake_args(install_libdir: lib)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end

class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 4
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5761a1b754e8c9bc0a3ba1c03b701dd56673a1f31461343d2e1fc6ad8a9bdc99"
    sha256 cellar: :any,                 arm64_monterey: "d034d2dfae9b19d297649bad8220f4a9016c7a6cbe79c955986601299d85f704"
    sha256 cellar: :any,                 arm64_big_sur:  "af59314cd471c0f86e585f1c0108fee3b77cd7fad4b4004ce89a44482607b7a8"
    sha256 cellar: :any,                 ventura:        "f7ff8c65a757e6ec83bb686e935b8834c4bec3e8a9606843d1255f3e80e6e46b"
    sha256 cellar: :any,                 monterey:       "5f8083f2ef27db1ffe8b2597bce36a5eba8bdd3072bffa66477b18251516f158"
    sha256 cellar: :any,                 big_sur:        "0eb647b73d59a179537d1eacbb4b0c3a76444466e69a7100785a11478bfb12a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47e9861c305a2242aa2b1dfc02f457ce7fde9046bc07a914a50788b731d7f9fe"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end

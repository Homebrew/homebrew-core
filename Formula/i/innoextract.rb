class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 7
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cedb442450932b1917270127408d965d2e16518532acd2d9b2de036c3cd3afa5"
    sha256 cellar: :any,                 arm64_ventura:  "1b50e00498c595c57fd02d5c57a1214e5953700f3f79917557c7a1db2f548c3c"
    sha256 cellar: :any,                 arm64_monterey: "c2459718752d6f6cf36cbdd9cbe8dc86dbe83fec019d8ea0869ad167d9e84819"
    sha256 cellar: :any,                 sonoma:         "e08b29caa2a39149ba4645a71ea920343fc601c2d2490a0596c732290e628a5e"
    sha256 cellar: :any,                 ventura:        "2f3d4a7961a5761d4e31eb3cad34894078b5eea45b2c5b47a31f54275c1ab25f"
    sha256 cellar: :any,                 monterey:       "9bd821f8242787c7a368ada0012ac2be987d5e812245f6ba14bd395fdd15d6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4b51f0663f2bd29890f309a2064c0b96365ff5e59ddf3bbafda1e08b7f053cb"
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

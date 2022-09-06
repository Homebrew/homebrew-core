class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 3
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "57dec1589632c3bcfb86c7402b2f323a0e30123f69424a71522260ea98268555"
    sha256 cellar: :any,                 arm64_big_sur:  "26f0785a2b94720a7c4f50ebb44a410644bae4a34d60c2183a2f53d5eb006ba6"
    sha256 cellar: :any,                 monterey:       "13752b1f734b83fe450c8580ea2c267c14d29cff4e55a7ab37aeccf168f44059"
    sha256 cellar: :any,                 big_sur:        "e9027a847d367e94e2a3bcd28dbda59516eb85b44a82d0cdff72863f2f72fb19"
    sha256 cellar: :any,                 catalina:       "43741a15dff324bdf57d0b97c6ebd30a8a05e27cb5e931788e9e2a3010e4e7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5d734c33916760cbe52c7ebdb338566a0d85e3ade9b8085c1abd3264b9ea93e"
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

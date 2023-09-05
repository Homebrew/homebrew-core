class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 5
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ebcb60a9fe025e08d6d8c0f45f99e5a9cb366ccb8d2e0b4daea489c62c194ca5"
    sha256 cellar: :any,                 arm64_monterey: "e623de0fda46002192554731817a9649e297e0f8910497037e542a9c543461bc"
    sha256 cellar: :any,                 arm64_big_sur:  "7386d13c829e8f9811e30ed8e5b2560497ded75196d9aa069ceb7fa781145153"
    sha256 cellar: :any,                 ventura:        "fbe7a2614f803edf24c8bf694dedcdb347d3dd83930b45874e8df2cef6af8361"
    sha256 cellar: :any,                 monterey:       "dc205a7c6e14aebebe36249f8ed7be173216e62e3e80f725afed17540455f083"
    sha256 cellar: :any,                 big_sur:        "cab8494a91d792086cf4de85f12e9eb4cd0ba02ff686ba34eb923035b2d7b31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea25a9572bf392c5efc94ba0b1786a669ce3b23069fba8c67e3eeab825cae06b"
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

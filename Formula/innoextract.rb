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
    sha256 cellar: :any,                 arm64_ventura:  "dda80f3622f51914c7b6f3c4b7a8f8545ea8a71315c886591c2b84cadc9d8eb4"
    sha256 cellar: :any,                 arm64_monterey: "9ee72f555539ca423420c6ec83bdb7fb549f8727e4fc5fec25f47593760809ab"
    sha256 cellar: :any,                 arm64_big_sur:  "1dda1fcae2b4243cfbb565b36b0554b003920e43e18dc479837191efc1f368e4"
    sha256 cellar: :any,                 ventura:        "c995201988238dae16cc43d3ed49c31829a2283c518aff52f6408a87ec447461"
    sha256 cellar: :any,                 monterey:       "cf7c24ad28cc0aaf358d4d6b676a1ac73e2ffe583cd26149575974c0eb0aa7e0"
    sha256 cellar: :any,                 big_sur:        "36269c001615fe060fcf4a91cfae2e273785e951b5e12402254a1158963bd580"
    sha256 cellar: :any,                 catalina:       "749d13cbe03a8e4d189b47b942f86b42f488508abbfc179a02950eddf1f6034a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37aa76c6b8ff612462fadf8ffd38b53cbff299d974b8065c27c08ca06c13028c"
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

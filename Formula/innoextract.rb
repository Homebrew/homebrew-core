class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  head "https://github.com/dscharrer/innoextract.git"
  stable do
    url "https://constexpr.org/innoextract/files/innoextract-1.8.tar.gz"
    sha256 "5e78f6295119eeda08a54dcac75306a1a4a40d0cb812ff3cd405e9862c285269"

    # Boost 1.70+ compatibility. Remove with next release. b47f46 is
    # already in master.
    patch do
      url "https://github.com/dscharrer/innoextract/commit/b47f46102bccf1d813ca159230029b0cd820ceff.patch?full_index=1"
      sha256 "92d321d552a65e16ae6df992a653839fb19de79aa77388c651bf57b3c582d546"
    end
  end

  bottle do
    cellar :any
    sha256 "d3a81822f7925b57904c0c669c4296b3ed0df8551c1cc3039c58341af674bf01" => :catalina
    sha256 "c83524adccf3e591b2e72a7cc72668972f379a9aad9f8a555cc2ce3fa0a90143" => :mojave
    sha256 "92323fd4044aae1db881b3e18ce58b8c51e77a8b745b4e9c120e500cf2cb3ed1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end

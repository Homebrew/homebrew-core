class Htmlcxx < Formula
  desc "Non-validating CSS1 and HTML parser for C++"
  homepage "https://htmlcxx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htmlcxx/v0.87/htmlcxx-0.87.tar.gz"
  sha256 "5d38f938cf4df9a298a5346af27195fffabfef9f460fc2a02233cbcfa8fc75c8"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "5afe59e8f11f3ee3d04448c1e885b433cdcb356c6aaa80bc1e8ed0f6b0c0ec95" => :big_sur
    sha256 "076a461f50d225b8f6d7b1d1541b0fcdb2fba0af77e28d2524815e5d912b623e" => :arm64_big_sur
    sha256 "8414d919ae850983832803af525e8b98d3e5aa106c47b05f420d77020c7c99ca" => :catalina
    sha256 "e910595c43c028e25e0e0a44203e3c95b229162ea89678721b4a7f6e22974aca" => :mojave
    sha256 "062a4b1629ab6f28e59ef0ea15c257c8bfd9e3646f3342fbfe14268727be7649" => :high_sierra
    sha256 "4407cb1a50e8d629db9b93bdbbbf2a0892967611f7e579c49c0d084769f8a5ca" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/htmlcxx -V 2>&1").chomp
  end
end

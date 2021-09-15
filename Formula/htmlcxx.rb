class Htmlcxx < Formula
  desc "Non-validating CSS1 and HTML parser for C++"
  homepage "https://htmlcxx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htmlcxx/v0.87/htmlcxx-0.87.tar.gz"
  sha256 "5d38f938cf4df9a298a5346af27195fffabfef9f460fc2a02233cbcfa8fc75c8"

  bottle do
    sha256 arm64_big_sur: "076a461f50d225b8f6d7b1d1541b0fcdb2fba0af77e28d2524815e5d912b623e"
    sha256 big_sur:       "5afe59e8f11f3ee3d04448c1e885b433cdcb356c6aaa80bc1e8ed0f6b0c0ec95"
    sha256 catalina:      "8414d919ae850983832803af525e8b98d3e5aa106c47b05f420d77020c7c99ca"
    sha256 mojave:        "e910595c43c028e25e0e0a44203e3c95b229162ea89678721b4a7f6e22974aca"
    sha256 high_sierra:   "062a4b1629ab6f28e59ef0ea15c257c8bfd9e3646f3342fbfe14268727be7649"
    sha256 sierra:        "4407cb1a50e8d629db9b93bdbbbf2a0892967611f7e579c49c0d084769f8a5ca"
    sha256 x86_64_linux:  "ba29d98077036799d68c6c6dc56e0e7fa28aee700a89f4128a2d10a29d1ab39e"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/htmlcxx -V 2>&1").chomp
  end
end

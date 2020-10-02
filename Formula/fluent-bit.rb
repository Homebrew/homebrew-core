class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.5.7.tar.gz"
  sha256 "499618fc8da1fda83ca3967dc6d2102f427f2a333346604e4750d2c3578b9f39"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "56da409772b2d4f93cdb381e21e694111aee4d26957c4da1b782e0de353865fa" => :catalina
    sha256 "b895c9b081b58640d6652651ab4bada2c1459638dbe31aa143287f9b507f9a1b" => :mojave
    sha256 "1e98f8c278d93c5acdb07fd0cf125960070c034b490451d1bd854d8bbcbde03d" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end

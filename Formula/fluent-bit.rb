class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.8.tar.gz"
  sha256 "214c800d8f1f0cd74cdc772775481e054546228194b4e49b50fe36e924b6ea03"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "06508434ae4db5b431a3ea919de492d7328aa9ea7bc1fac119ecad151da6324a" => :big_sur
    sha256 "27d7d15303379fbbe0b752046cfca4085466b5d3688eef19dbe10db2333ce22f" => :catalina
    sha256 "f3769062550cb97119a30186eb14454c29619a8ab8066a12a78d8e7164bbc158" => :mojave
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

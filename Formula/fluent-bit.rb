class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.4.tar.gz"
  sha256 "a81b4d6b7b6481f7d82291edccd33f4fc48f739b14908b0be1f6299b7ceb2bd5"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "5bd5a7adde463a09682eb2e19db6d5c92db9e6c94fdd3ceb9bd46d106f711527" => :catalina
    sha256 "b5a3a016d01bc023af296d016425f5ab686163bd024d2006a8b56c6ed53e348f" => :mojave
    sha256 "7dfb0125da573b21dc80704f40d457710fab605540de302d7fd3c9ff77429e07" => :high_sierra
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

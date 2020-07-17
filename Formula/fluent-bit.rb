class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.5.1.tar.gz"
  sha256 "c3daec42a54adf441d70923374f1b003aa987d544346949e9a0b6a59490ffd7f"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "b173bfe688e0fb2d3fc17346e484b1498a11880fb168a2cb69fa3061fc7b923c" => :catalina
    sha256 "98a8197dd2fa07771bf2d475efc418b55df0e7ee81d30c03ab103dc0cf6459cd" => :mojave
    sha256 "c370216e949481b1a825b8a16e8bee1cabdf1e3fa264aaf29aa81b4e4765a192" => :high_sierra
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

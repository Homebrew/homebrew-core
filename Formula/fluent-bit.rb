class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.1.tar.gz"
  sha256 "1e0153d03ab6223f330602f5cbcc368cd57813f99942fe536ba1f367c5e22484"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "40ccb5eef5c8435d7dfb9fca2e0a7290b6452022ab16a93d4561872011993e6e" => :catalina
    sha256 "a0ec424da02c4a768d40528de416b63f03453ed4981729846f955db095cafe11" => :mojave
    sha256 "e0c8be899457517500a3424abb73f9ec8e9d2ad6b25efd7d6fb691055bea1005" => :high_sierra
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

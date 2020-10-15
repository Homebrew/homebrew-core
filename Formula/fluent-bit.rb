class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.0.tar.gz"
  sha256 "6be8cba2a0817cc1f50bfdbb7c4165bdef76e5207cd63ed14f478675d70295b6"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "35710972ebefbc5d57e250e0a712db29e206f75a13ff9c74e6f8ddc2e37f4ff0" => :catalina
    sha256 "b2e60f4e6138473288e9ffdec4b7cdedcfc7dfccc4a9474aec0dd8acffb49801" => :mojave
    sha256 "9d041cdb4a8e3375e9a98ee22a125d842df5ad58073c3d5912033d49779dfcf9" => :high_sierra
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

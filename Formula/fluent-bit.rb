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
    sha256 "3f01be1f32441b6b1bdfade76bbb4d911587198783b5890557cd9aad4091964f" => :catalina
    sha256 "4b9787180b92ecdd572a3ff35b24fb80838be589c49e199e85e0a39fd0c7a479" => :mojave
    sha256 "3ed5113a853e3af32685a639a2656a59d91cb025a633b4eee6bc1c47c59f82b4" => :high_sierra
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

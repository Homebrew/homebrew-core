class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.9.1/c/avro-c-1.9.1.tar.gz"
  sha256 "7df7bc1e13ce7180f0438ed05ab6642b5b2b6df91f30b927b470e25a78e04642"

  bottle do
    sha256 "46eed9b02091bc06e0a1007beed901d6fe8f19366e86e4544103e4f7f43a2e28" => :catalina
    sha256 "35aa07886a5188fc42edf2c4dd473857420f9e2ab8b981c4ebd08fabbbe32455" => :mojave
    sha256 "4ab18f360192adcd9900308820cb06b706d12b997a07b7f2fa6bf1366a91c477" => :high_sierra
    sha256 "0e24c43c6b2d1c356fdb135f0d94afaaf1274c922f7e58abf4c51581925da572" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "tests/test_avro_1087"
  end

  test do
    assert shell_output("#{pkgshare}/test_avro_1087")
  end
end

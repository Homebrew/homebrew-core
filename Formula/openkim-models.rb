class OpenkimModels < Formula
  desc "All OpenKIM Models compatible with kim-api"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/archives/collection/openkim-models-2019-07-25.txz"
  sha256 "50338084ece92ec0fb13b0bbdf357b5d7450e26068ba501f23c315f814befc26"

  bottle do
    sha256 "b722a8aa05f31f23d32f46381f20a3a3353dadd1f993f2a3c1b4b43739b55acf" => :mojave
    sha256 "c146912a215949046161e5a54176aa45c66bf5babf3774b1af5a5084b0b4de77" => :high_sierra
    sha256 "2a5b50566f16c975c9933ec6af6e3517f2f5ddb4a06265cd1369679077e6db4c" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "kim-api"

  def install
    args = std_cmake_args
    args << "-DKIM_API_MODEL_DRIVER_INSTALL_PREFIX=#{lib}/openkim-models/model-drivers"
    args << "-DKIM_API_PORTABLE_MODEL_INSTALL_PREFIX=#{lib}/openkim-models/portable-models"
    args << "-DKIM_API_SIMULATOR_MODEL_INSTALL_PREFIX=#{lib}/openkim-models/simulator-models"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    output = shell_output("kim-api-collections-management list")
    assert_match "LJ_ElliottAkerson_2015_Universal__MO_959249795837_003", output
  end
end

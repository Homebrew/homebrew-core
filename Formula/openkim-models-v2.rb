class OpenkimModelsV2 < Formula
  desc "All OpenKIM Models compatible with kim-api-v2"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/archives/collection/OpenKIM-Models-v2-2019-02-21.txz"
  sha256 "3bd30b0cf2bab314755a66eed621a77c72d3f990818d08366874149be39f208e"

  depends_on "cmake" => :build
  depends_on "kim-api-v2"

  def install
    args = std_cmake_args
    args << "-DKIM_API_MODEL_INSTALL_PREFIX=#{lib}/kim-api-v2/models"
    args << "-DKIM_API_MODEL_DRIVER_INSTALL_PREFIX=#{lib}/kim-api-v2/model-drivers"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "kim-api-v2-collections-management list > ./out"
    system "grep", "LJ_ElliottAkerson_2015_Universal__MO_959249795837_003", "./out"
  end
end

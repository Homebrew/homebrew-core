class OpenkimModels < Formula
  desc "All OpenKIM Models compatible with kim-api"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/archives/collection/openkim-models-2019-03-29.txz"
  sha256 "053dda2023fe4bb6d7c1d66530c758c4e633bbf1f1be17b6b075b276fe8874f6"

  depends_on "cmake" => :build
  depends_on "kim-api"

  def install
    args = std_cmake_args
    args << "-DKIM_API_MODEL_DRIVER_INSTALL_PREFIX=#{lib}/openkim-models/model-drivers"
    args << "-DKIM_API_MODEL_INSTALL_PREFIX=#{lib}/openkim-models/models"
    args << "-DKIM_API_SIMULATOR_MODEL_INSTALL_PREFIX=#{lib}/openkim-models/simulator-models"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    output = shell_output("kim-api-collections-management list")
    assert_match "LJ_ElliottAkerson_2015_Universal__MO_959249795837_003", output
  end
end

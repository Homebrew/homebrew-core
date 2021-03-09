class OpenkimModels < Formula
  desc "All OpenKIM Models compatible with kim-api"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/archives/collection/openkim-models-2021-01-28.txz"
  sha256 "8824adee02ae4583bd378cc81140fbb49515c5965708ee98d856d122d48dd95f"

  livecheck do
    url "https://s3.openkim.org/archives/collection/"
    regex(/href=.*?openkim-models[._-]v?(\d+(?:-\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "359a82d6289b65b90e0ab697fd1cd58215c3dd6d4c0235c72495060b604cf13f"
    sha256 cellar: :any, catalina: "e4c844b70c144d9b0003a98b09110264524fe0215dbc659ec9eb294f89c6ed44"
    sha256 cellar: :any, mojave:   "e48969cbccc17768708e4e181a2fc81b486e29b8ac831a9c1c9ada5e81b1224f"
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

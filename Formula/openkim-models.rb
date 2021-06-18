class OpenkimModels < Formula
  desc "All OpenKIM Models compatible with kim-api"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/archives/collection/openkim-models-2021-01-28.txz"
  sha256 "8824adee02ae4583bd378cc81140fbb49515c5965708ee98d856d122d48dd95f"
  revision 1

  livecheck do
    url "https://s3.openkim.org/archives/collection/"
    regex(/href=.*?openkim-models[._-]v?(\d+(?:-\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8420a6f9b22e2dde317de3ac2d553c0b091e56d3c47983257c7531c0dde3b821"
    sha256 cellar: :any, big_sur:       "acf19d2bbfb541de82b65b432ab325ef184d59337d29294ac7e92199b13733e7"
    sha256 cellar: :any, catalina:      "fac77a3d80f5a7a3a7729f7dc2d8ec033cc443e8b88134ed1da35fbc57eccc67"
    sha256 cellar: :any, mojave:        "d7248765fbc3c62c1073767d2ab0a9fe1b4cc4117d101aee9c8a8e8e6cd6cb15"
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

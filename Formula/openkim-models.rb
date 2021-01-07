class OpenkimModels < Formula
  desc "All OpenKIM Models compatible with kim-api"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/archives/collection/openkim-models-2019-07-25.txz"
  sha256 "50338084ece92ec0fb13b0bbdf357b5d7450e26068ba501f23c315f814befc26"
  revision 1

  livecheck do
    url "https://s3.openkim.org/archives/collection/"
    regex(/href=.*?openkim-models[._-]v?(\d+(?:-\d+)+)\.t/i)
  end

  bottle do
    sha256 "d8eb0ffb78085bf3d5770d022378d82631e75c8975611bcd4f6b63a33f0ef74c" => :big_sur
    sha256 "9420d4f91176705c43778e8566407d3310924b35dc0e10c3ceaaac86dc5c3713" => :catalina
    sha256 "236e77924307da8aa61a6a34242dd1623d501db8ef408e3c33d3ca8b4ca387f4" => :mojave
    sha256 "d962559c861be90a61189489af855947e8cd883a3480863c4097a3b1a0410e6f" => :high_sierra
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

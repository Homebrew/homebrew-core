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
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "c84dd2bcb561dea50e0890a2016744cfa5f4bc1a310f8e43eed6d53768aaac9d"
    sha256 cellar: :any,                 big_sur:       "f71c1aa57dfc25bd1cccd0bcf86ae67b9ba872bfa780e95c79f1d54eac766bb1"
    sha256 cellar: :any,                 catalina:      "10181a42e24ccb061f9888d4836185c7e2ef90f933e16dd46bc6915da97cdba9"
    sha256 cellar: :any,                 mojave:        "84abe876ab9f3ea248ad45720ef4c73d3e3ae8b92e6f2fba2e05b33356795e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "994752e228bd4fca2f91bb77c17f528289c579cc5474e3b741aced87009608e5"
  end

  depends_on "cmake" => :build
  depends_on "kim-api"

  def install
    args = std_cmake_args + %W[
      -DKIM_API_MODEL_DRIVER_INSTALL_PREFIX=#{lib}/openkim-models/model-drivers
      -DKIM_API_PORTABLE_MODEL_INSTALL_PREFIX=#{lib}/openkim-models/portable-models
      -DKIM_API_SIMULATOR_MODEL_INSTALL_PREFIX=#{lib}/openkim-models/simulator-models
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    output = shell_output("kim-api-collections-management list")
    assert_match "LJ_ElliottAkerson_2015_Universal__MO_959249795837_003", output
  end
end

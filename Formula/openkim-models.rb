class OpenkimModels < Formula
  desc "All OpenKIM Models compatible with kim-api"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/archives/collection/openkim-models-2021-08-11.txz"
  sha256 "f42d241969787297d839823bdd5528bc9324cd2d85f5cf2054866e654ce576da"

  livecheck do
    url "https://s3.openkim.org/archives/collection/"
    regex(/href=.*?openkim-models[._-]v?(\d+(?:-\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "763adc2f08934f30279506792efee7a17f538927ddc123f0c09f263b0495aa0b"
    sha256 cellar: :any,                 monterey:      "cf230e121f3333365f469b962aab55714e5795bfaefb4a7a96313b2ee6b4985f"
    sha256 cellar: :any,                 big_sur:       "4c0c49b3ff34e3656e1d1dce4ebcbec296851ad6c20c417f31b97a2b5f6bb779"
    sha256 cellar: :any,                 catalina:      "3f8e0b64864f1f03dd0a22801ee2a03ed80540a033f107a2dbfb6f3758beff86"
    sha256 cellar: :any,                 mojave:        "57c577a620d2cba560232d4d5cd189816580d22f93403330431d3970496a626c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "780e5600aecda03574243907a2e77ddf77a61d2e41a8aee15e5c6b440742e262"
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

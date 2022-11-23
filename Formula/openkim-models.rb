class OpenkimModels < Formula
  desc "All OpenKIM Models compatible with kim-api"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/archives/collection/openkim-models-2021-08-11.txz", using: :homebrew_curl
  sha256 "f42d241969787297d839823bdd5528bc9324cd2d85f5cf2054866e654ce576da"
  license "CDDL-1.0"
  revision 1

  livecheck do
    url "https://s3.openkim.org/archives/collection/"
    regex(/href=.*?openkim-models[._-]v?(\d+(?:-\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "458fc81fd6c2a1b3e0599f4ac40c1d40d7168f32407ec6f3c34db3b4215daa63"
    sha256 cellar: :any,                 arm64_monterey: "58cbde998d51cce50b663b5b5aa11cbf9e4f5c6709a01e8b4987b09702ac27e7"
    sha256 cellar: :any,                 arm64_big_sur:  "d6a0d32d4b8294e21121821eae9cb1c09b8c931f50216336b2b58fc16339655f"
    sha256 cellar: :any,                 ventura:        "acf39b7ad37d761a964977286b954a7bee4d3e8d587e5c5bea6ae697765c5269"
    sha256 cellar: :any,                 monterey:       "be743d4bb17d99cabec6bd66e5ca8b486ba4c98722a4a6d8ff5e473e5ee0c6fb"
    sha256 cellar: :any,                 big_sur:        "0000ba2923c829367dc9e2b39c88935785aa18e5b536ab5237d61e9057bf5729"
    sha256 cellar: :any,                 catalina:       "f07f32fc9be97e8a285fc350d18feb98bbf58a8b0a4be8ee7fde853053216cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10942f7fcbe44a43a4390fceef8b8b508c80c020ce5dec6101b3b30bc3977e7"
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

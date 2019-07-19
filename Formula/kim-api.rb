class KimApi < Formula
  desc "The Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.1.0.txz"
  sha256 "d6b154b31b288ec0a5643db176950ed71f1ca83a146af210a1d5d01cce8ce958"

  bottle do
    sha256 "eca745c93c6948fa76bfe18e98069d5ceb54abf959a1900efaf1a2ecc4c07c9f" => :mojave
    sha256 "ecae4807ef18a2a6f4af932db3243967e1e8021e695ae40fbbffe06dd32413c4" => :high_sierra
    sha256 "3b6e87b12ab2441d0bc0f7bf11345d5e022fdd1da5d9e42ea216e37d2ef857e3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" # for gfortran

  def install
    args = std_cmake_args
    # adjust directories for system collection
    args << "-DKIM_API_SYSTEM_MODEL_DRIVERS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/model-drivers"
    args << "-DKIM_API_SYSTEM_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/models"
    args << "-DKIM_API_SYSTEM_SIMULATOR_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/simulator-models"
    system "cmake", ".", *args
    system "make"
    system "make", "docs"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/kim-api-collections-management list")
    assert_match "Sim_LAMMPS_LJcut_AkersonElliott_Alchemy_PbAu", output
  end
end

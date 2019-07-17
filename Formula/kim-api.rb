class KimApi < Formula
  desc "The Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.1.1.txz"
  sha256 "25c4e83c6caa83a1c4ad480b430f1926fb44813b64f548fdaedc45e310b5f6b9"

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
    # adjust compiler settings for package
    args << "-DKIM_API_CMAKE_C_COMPILER=/usr/bin/clang"
    args << "-DKIM_API_CMAKE_CXX_COMPILER=/usr/bin/clang++"
    # adjust directories for system collection
    args << "-DKIM_API_SYSTEM_MODEL_DRIVERS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/model-drivers"
    args << "-DKIM_API_SYSTEM_PORTABLE_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/portable-models"
    args << "-DKIM_API_SYSTEM_SIMULATOR_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/simulator-models"
    system "cmake", ".", *args
    system "make"
    system "make", "docs"
    system "make", "install"
    zsh_completion.install "#{prefix}/etc/zsh_completion.d/kim-api-collections-management.zsh" => "_kim-api-collections-management"
  end

  test do
    output = shell_output("#{bin}/kim-api-collections-management list")
    assert_match "ex_model_Ar_P_Morse_07C_w_Extensions", output
  end
end

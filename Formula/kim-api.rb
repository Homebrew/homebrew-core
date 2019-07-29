class KimApi < Formula
  desc "The Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.1.1.txz"
  sha256 "25c4e83c6caa83a1c4ad480b430f1926fb44813b64f548fdaedc45e310b5f6b9"

  bottle do
    sha256 "655e139ffab7c583324cd6a2a1904793567577c1cfbf05a2562c32ec5c2306b8" => :mojave
    sha256 "e2fba1844e3737c0f0dfca0da5f1c86cdf3bb8aeaa07d50bb30b8d97e618b5cf" => :high_sierra
    sha256 "65b376444cf8ec498a2074e4e186e124cd1ea8fe210437fea307def5aa48c1b2" => :sierra
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

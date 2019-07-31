class KimApi < Formula
  desc "The Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.1.2.txz"
  sha256 "16c7dd362cf95288b6288e1a76caf8baef652eb2cf8af500a5eb4767ba2fe80c"

  bottle do
    sha256 "5a1c01f149cad15cfeb545aef0d918212df00ad323243363ec6750287f7cf35a" => :mojave
    sha256 "e9e5469c3e41d45e450903bcece7c1dbcc419ac2b8f720088d254f38dd6fe99b" => :high_sierra
    sha256 "421cc4147e8d28823f512a4aee7c0859f0d300bb8942bc9dbb1435a71a93663e" => :sierra
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
    # adjust zsh completion install
    args << "-DZSH_COMPLETION_COMPLETIONSDIR=#{zsh_completion}"
    system "cmake", ".", *args
    system "make"
    system "make", "docs"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/kim-api-collections-management list")
    assert_match "ex_model_Ar_P_Morse_07C_w_Extensions", output
  end
end

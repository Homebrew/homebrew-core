class KimApi < Formula
  desc "The Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.1.3.txz"
  sha256 "88a5416006c65a2940d82fad49de0885aead05bfa8b59f87d287db5516b9c467"
  revision 1

  livecheck do
    url "https://openkim.org/kim-api/previous-versions/"
    regex(/href=.*?kim-api[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "585be65f52b6c5dd3b9c5ea0da1af889e24ef085f8174485d9256b84d9b01d84" => :catalina
    sha256 "29743babbc332f529773cba2962512e3d29c0e269675bbb033effedbe1f92da3" => :mojave
    sha256 "8f64683177ac688908e33c98ca57ae3b2c3c59215e70b77296b40843b6e69a0f" => :high_sierra
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

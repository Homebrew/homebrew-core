class KimApi < Formula
  desc "The Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.1.3.txz"
  sha256 "88a5416006c65a2940d82fad49de0885aead05bfa8b59f87d287db5516b9c467"

  bottle do
    sha256 "ae59f45bf8d539f1b633120cdb942c2a0a0f1880eee4ee91981f268792e1b1c4" => :catalina
    sha256 "f652b6fac2383753b53c16f22b4cd64ca96adaf5b61906e8a51d893fb453588a" => :mojave
    sha256 "05e8711131862fa14cc38277d33694be33d488bbcb5efc9e59a54c67ca1df2ea" => :high_sierra
    sha256 "31502a90222cdeffb15c7b1ad820fcae8780c6db807634e23917bd182691c0ee" => :sierra
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

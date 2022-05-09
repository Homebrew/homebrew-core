class KimApi < Formula
  desc "Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.3.0.txz", using: :homebrew_curl
  sha256 "93673bb8fbc0625791f2ee67915d1672793366d10cabc63e373196862c14f991"
  license "CDDL-1.0"

  livecheck do
    url "https://openkim.org/kim-api/previous-versions/"
    regex(/href=.*?kim-api[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b92cc266d748a98e897612a3492173ed6f4e697bab3456cfe73c164238acf44c"
    sha256 cellar: :any,                 arm64_big_sur:  "8f5408a02b09db05073d67e0a5b9f434227ed4fe5a5283152a0c35ec1c6b4a14"
    sha256 cellar: :any,                 monterey:       "625429556163329924c57a73aa91396a3ff10e9e459781d4b29f7143e193a68f"
    sha256 cellar: :any,                 big_sur:        "f5e4e77f769ac4bdb55a6cd3872fc0157602f7a8e9ca0d4a49c11cb09ddebd71"
    sha256 cellar: :any,                 catalina:       "f91f86a9cb4cfaca70ae47d038914c9a083505c5584ae7f1e977472f2028ae11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "433e83ed6dff896362dc21c6a2e2221f2b94d2e9a70fcebf230ce13a86ed434a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" # for gfortran

  uses_from_macos "xz"

  def install
    args = std_cmake_args + [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      # adjust libexec dir
      "-DCMAKE_INSTALL_LIBEXECDIR=lib",
      # adjust directories for system collection
      "-DKIM_API_SYSTEM_MODEL_DRIVERS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/model-drivers",
      "-DKIM_API_SYSTEM_PORTABLE_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/portable-models",
      "-DKIM_API_SYSTEM_SIMULATOR_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/simulator-models",
      # adjust zsh completion install
      "-DZSH_COMPLETION_COMPLETIONSDIR=#{zsh_completion}",
      "-DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}",
    ]
    # adjust compiler settings for package
    if OS.mac?
      args << "-DKIM_API_CMAKE_C_COMPILER=/usr/bin/clang"
      args << "-DKIM_API_CMAKE_CXX_COMPILER=/usr/bin/clang++"
    else
      args << "-DKIM_API_CMAKE_C_COMPILER=/usr/bin/gcc"
      args << "-DKIM_API_CMAKE_CXX_COMPILER=/usr/bin/g++"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "docs"
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/kim-api-collections-management list")
    assert_match "ex_model_Ar_P_Morse_07C_w_Extensions", output
  end
end

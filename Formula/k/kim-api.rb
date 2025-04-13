class KimApi < Formula
  desc "Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.4.0.txz"
  sha256 "0fa030843ce89ae399d27a61e9a075a60328df618868fdad92f24fdf9fd33032"
  license "CDDL-1.0"

  livecheck do
    url "https://openkim.org/kim-api/previous-versions/"
    regex(/href=.*?kim-api[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a9a82aee329b1ac9049c763053f5b97114bc546fdadd69f830ab7cbf49024e0"
    sha256 cellar: :any,                 arm64_sonoma:  "1bd044a9580fc0761c012c3c91d7d784ab5d31ad9d0a35e731ec05931a2fdfd0"
    sha256 cellar: :any,                 arm64_ventura: "1ffa80813a49f7990fee29ec83c4ef03182e92e3cf1ad3e174ff6c6042ed670a"
    sha256 cellar: :any,                 sonoma:        "6ab3b70a938f7a2b2c1e97f59640c4c12bf34fca9f9bab2f1002ff64f33eb0b4"
    sha256 cellar: :any,                 ventura:       "e612e98c59c0a7650513e7d775ee45099ba82d8bb563825eb3e3e82b22905cd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54f332ed31a02dc3c11776b8c1b555c268843b6e41cc85c25e7389df480490f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15501b1a05f5a4f1fd5d3bffaed6d1715d6a1b4964a2ff37add87dca7919bc76"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" # for gfortran

  uses_from_macos "xz"

  def install
    args = [
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "docs"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/kim-api-collections-management list")
    assert_match "ex_model_Ar_P_Morse_07C_w_Extensions", output
  end
end

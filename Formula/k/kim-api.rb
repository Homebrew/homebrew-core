class KimApi < Formula
  desc "Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.4.1.txz"
  sha256 "225e3136d43e416a4424551e9e5f6d92cc6ecfe11389a1b6e97d6dcdfed83d44"
  license "CDDL-1.0"

  livecheck do
    url "https://openkim.org/kim-api/previous-versions/"
    regex(/href=.*?kim-api[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d79142cae17a24d254880b026a8137762fe02c82bed8f3b7350f18a8ffd5dda8"
    sha256 cellar: :any,                 arm64_sequoia: "6f92c783490359b5af15dca8d0b8384392640aedecbb60690c11ebe3cb3f6e54"
    sha256 cellar: :any,                 arm64_sonoma:  "e0c81eb361cbad87a74edfff4746cc111516a16227b1e771d9bbfc1e12681fe7"
    sha256 cellar: :any,                 sonoma:        "cdf27f43903be385039cf5807c405594077dab622db22ca2b6769852386ccbd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e993a48b7e16c52e42273e60fca86c3c3a7020ebde221107bfe9cc5478c29e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "471b9f1da935d02529fee88ca227059900744cd0d61444ae94e5e0a3f6f8198e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" # for gfortran

  uses_from_macos "xz"

  def install
    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpath};#{loader_path}/../../..",
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

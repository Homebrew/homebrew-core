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
    sha256 cellar: :any,                 arm64_tahoe:   "6f5066e030212361416ff286ce20bb6d45d0c87a5225cdabd4905b29e2abfd90"
    sha256 cellar: :any,                 arm64_sequoia: "c8214b21245469eccfe7693dacb9146bd28a71c0dbcf60f2655cc664e2ae65bc"
    sha256 cellar: :any,                 arm64_sonoma:  "19feb0d8847607b24f869cb2d82c7378d4196a7c7ae2224e6f33f5d54aa47e3d"
    sha256 cellar: :any,                 arm64_ventura: "67b165f2b4604391a1fefb0554bbe3a3260ef5ddd789479925f857ee7cb59893"
    sha256 cellar: :any,                 sonoma:        "238895ca76d8aeb1e2759426a25d726a5e5754cbd77ae48fecc871dfe4aa94e4"
    sha256 cellar: :any,                 ventura:       "594b5361fb31557732acdb6d373be537aafca3e39731e6eecae5c4d4f63b0f08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "591e234dddd71d0bbbf44bf0b3c948279f10822b5bfb6d437b53597ab6b030a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b9c0aa802b5478594414159c28c7dbe8304ac91d965b176f20ffbd269fc131f"
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

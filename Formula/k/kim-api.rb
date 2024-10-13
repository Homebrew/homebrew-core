class KimApi < Formula
  desc "Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.3.0.txz", using: :homebrew_curl
  sha256 "93673bb8fbc0625791f2ee67915d1672793366d10cabc63e373196862c14f991"
  license "CDDL-1.0"
  revision 1

  livecheck do
    url "https://openkim.org/kim-api/previous-versions/"
    regex(/href=.*?kim-api[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "811ee36c198aa16f4c386447742ac00e8fd201e4e94ba600914db99b97f8ab9a"
    sha256 cellar: :any,                 arm64_sonoma:   "38c367b05aa6f93acdc85720ff28641867cf76675fe1c3f971c5490fce66e9cb"
    sha256 cellar: :any,                 arm64_ventura:  "86f1c14a312882376a61772792e0da4265f84bdd432db6db42afd2355b4c142f"
    sha256 cellar: :any,                 arm64_monterey: "a18d11cf459f99ca0c0f8a1d08d3f6a2ea762a1ca029e282b77227cdd3f432a9"
    sha256 cellar: :any,                 arm64_big_sur:  "c4d038b0db6fc374be824cfa325a775f8dd8556b406b69f8bce1cd51edab6ed5"
    sha256 cellar: :any,                 sonoma:         "92b6449a564453976bb94d098a7a04cd6542ac62f8e2245b47d604005c27b8ca"
    sha256 cellar: :any,                 ventura:        "0ee35d2e4ef210881f5245363970d59d6ca3a8f77a03f6c09f9e229e66649b59"
    sha256 cellar: :any,                 monterey:       "bfd052878e3b8a58ea1c496cc5c13499056af16c9ccdcdb95fa69db2f28b2525"
    sha256 cellar: :any,                 big_sur:        "f59251974403a7a5396aef8cd77cbe28d5a614fcadfa414c3d6a41de9e7863b1"
    sha256 cellar: :any,                 catalina:       "a02ca35858e1449c7022ca563b87367b639bd2905e1a9476029a2d01ab51d503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ee5ac6fe8da70f2734003c6348e8f094b354324bd7b6976e2ceaeb0d09c6ea1"
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

class KimApi < Formula
  desc "Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.4.2.txz"
  sha256 "1710bd6ceaea093062e000d2308719c51cc0a2d2def1bdcb0a03df8ed867b11f"
  license "CDDL-1.0"

  livecheck do
    url "https://openkim.org/kim-api/previous-versions/"
    regex(/href=.*?kim-api[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0d402382a7e3acc25fadf264e845cfd38ce6d90f3655c378131733b12b423ca"
    sha256 cellar: :any,                 arm64_sequoia: "1181985a7e96785c5ddc7260827b287d0d0903252dc8b3322f0a99cff91be5ea"
    sha256 cellar: :any,                 arm64_sonoma:  "a1c9e33c70217ca4bab42c68fcd75dc9f3fe85cde8b93921068d907bb66e7d56"
    sha256 cellar: :any,                 sonoma:        "7c2d3a557941e0592e68277f76e7313d3c29587622e5c073fed418c68de78f01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be9b43027b8e9b74b00523c55967e4473cdf1d8eb0502d30e591b804d76a0512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ab47d448baf6377f979a0c78ba00c1b5b85faa8d14a3a74026ba40df4edfea"
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

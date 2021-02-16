class KimApi < Formula
  desc "Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.2.1.txz"
  sha256 "1d5a12928f7e885ebe74759222091e48a7e46f77e98d9147e26638c955efbc8e"
  license "CDDL-1.0"
  revision 2

  livecheck do
    url "https://openkim.org/kim-api/previous-versions/"
    regex(/href=.*?kim-api[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "00b02a276ca2df5eb4b6b72aa310573bedbab3905999aa49591bcd7e2f1a4703"
    sha256 cellar: :any, catalina: "2da803d1ea94fa5dcc07fc0fc5afbe511e37c644b419623416ff443ef497dfaa"
    sha256 cellar: :any, mojave:   "ab1c2d8867c00ce7c4c3d5220c45fa84f8fe43e26e56d7be67718ba4da9c2cf1"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" # for gfortran

  def install
    # change file(COPY) to configure_file() to avoid symlink issue; will be fixed in 2.2.2
    inreplace "cmake/items-macros.cmake.in" do |s|
      s.gsub! /file\(COPY ([^ ]+) DESTINATION ([^ ]*)\)/, 'configure_file(\1 \2 COPYONLY)'
    end
    args = std_cmake_args
    # adjust compiler settings for package
    args << "-DKIM_API_CMAKE_C_COMPILER=/usr/bin/clang"
    args << "-DKIM_API_CMAKE_CXX_COMPILER=/usr/bin/clang++"
    # adjust libexec dir
    args << "-DCMAKE_INSTALL_LIBEXECDIR=lib"
    # adjust directories for system collection
    args << "-DKIM_API_SYSTEM_MODEL_DRIVERS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/model-drivers"
    args << "-DKIM_API_SYSTEM_PORTABLE_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/portable-models"
    args << "-DKIM_API_SYSTEM_SIMULATOR_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/simulator-models"
    # adjust zsh completion install
    args << "-DZSH_COMPLETION_COMPLETIONSDIR=#{zsh_completion}"
    args << "-DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}"
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

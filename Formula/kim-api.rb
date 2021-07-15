class KimApi < Formula
  desc "Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.2.1.txz"
  sha256 "1d5a12928f7e885ebe74759222091e48a7e46f77e98d9147e26638c955efbc8e"
  license "CDDL-1.0"
  revision 3

  livecheck do
    url "https://openkim.org/kim-api/previous-versions/"
    regex(/href=.*?kim-api[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ab32fa065b8d3c41fe08ccaf93ae403e91b3df9c689b49d22b64349499e5e595"
    sha256 cellar: :any,                 big_sur:       "f25c0ff199bc5c41842e992537af0602b9fe84fae6ebea234258d066da8c084c"
    sha256 cellar: :any,                 catalina:      "01da03836e0e268b9bd51958f8cc141210b6040023943fef58d8b12bd0a6b2f3"
    sha256 cellar: :any,                 mojave:        "43592f7c9e14fa4e1e453410f615f573e96eac0edd1117a063d586b385bee84a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "455d15683e8cb299ed98a09bd83660a0ef26a778271359543bca1564f3fab5a7"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" # for gfortran

  uses_from_macos "xz"

  def install
    # change file(COPY) to configure_file() to avoid symlink issue; will be fixed in 2.2.2
    inreplace "cmake/items-macros.cmake.in" do |s|
      s.gsub!(/file\(COPY ([^ ]+) DESTINATION ([^ ]*)\)/, 'configure_file(\1 \2 COPYONLY)')
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

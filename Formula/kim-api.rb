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
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "bc69df6522ce9a9f76399e03b78255ae82faedd70c5a8f3d4535de4d3f89f6a8"
    sha256 cellar: :any,                 monterey:      "0efba513c8067de36eb7ae2b27c538380f8d323a87a63dc7432965ee83c777b6"
    sha256 cellar: :any,                 big_sur:       "0324105634345be3ed3cb5f7bdd7d31379e84e5afdf966b3a699ad5355b8da49"
    sha256 cellar: :any,                 catalina:      "2d3e050c3af7adb392213906db110f79bc6c637a68a77231bcd94ca201555f2e"
    sha256 cellar: :any,                 mojave:        "34a1e8943c72ae99512a7069c08738f57f1b11e0adfb9a6ba5724ad953d06745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25cab6d99de536975418877447a40e436a884b16423056b06902f3aaf0884a61"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" # for gfortran

  uses_from_macos "xz"

  def install
    # change file(COPY) to configure_file() to avoid symlink issue; will be fixed in 2.2.2
    inreplace "cmake/items-macros.cmake.in", /file\(COPY ([^ ]+) DESTINATION ([^ ]*)\)/,
                                             "configure_file(\\1 \\2 COPYONLY)"
    args = std_cmake_args + [
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

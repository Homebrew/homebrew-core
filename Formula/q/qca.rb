class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.7/qca-2.3.7.tar.xz"
  sha256 "fee2343b54687d5be3e30fb33ce296ee50ac7ae5e23d7ab725f63ffdf7af3f43"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e27aa23d8cdafdb32c865d9550b2fbd376db1575863fd40b3d0e6b14f2615881"
    sha256 cellar: :any,                 arm64_ventura:  "f7c386d6484854c37b199fbd2229bf09d7c0feb4292dba7f31be570ea7a17c6e"
    sha256 cellar: :any,                 arm64_monterey: "a2c25cf1264e6bb33b1aaf8ec8525c58df60f0c003906469f77eda3c56e73518"
    sha256 cellar: :any,                 arm64_big_sur:  "c7ff822233c00931c5da4c22689269edcc5244fa7bc1ade0d213be11266c10a8"
    sha256 cellar: :any,                 sonoma:         "51a8b055769161b24dedef8cda4fd43c3972c664cf2f2aaed6b1b0f890209981"
    sha256 cellar: :any,                 ventura:        "1894df58bbbef4986d47d50edb3c49d189d9c1c0748b5cb80589e095222b2f26"
    sha256 cellar: :any,                 monterey:       "dae78d2860c8d11a268ae4f9ebcc62d1fcf7501d5ace5e3a93294539188860bc"
    sha256 cellar: :any,                 big_sur:        "2e63ba841df444e96470611e7adc7b8e4a88e23a735042780731fddeb5f78762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfdcd1c448ce4881ace28b56b9415a229cc597a73e778acabb7f4af061d95939"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "botan"
  depends_on "gnupg"
  depends_on "libgcrypt"
  depends_on "nss"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    # Make sure we link with OpenSSL 3 and not OpenSSL 1.1.
    openssl11 = Formula["openssl@1.1"]
    ENV.remove "CMAKE_PREFIX_PATH", openssl11.opt_prefix
    ENV.remove ["CMAKE_INCLUDE_PATH", "HOMEBREW_INCLUDE_PATHS"], openssl11.opt_include
    ENV.remove ["CMAKE_LIBRARY_PATH", "HOMEBREW_LIBRARY_PATHS"], openssl11.opt_lib

    args = %W[-DBUILD_TESTS=OFF -DQCA_PLUGINS_INSTALL_DIR=#{lib}/qt5/plugins]

    # Disable some plugins. qca-ossl, qca-cyrus-sasl, qca-logger,
    # qca-softstore are always built.
    %w[botan gcrypt gnupg nss pkcs11].each do |plugin|
      args << "-DWITH_#{plugin}_PLUGIN=ON"
    end

    # ensure opt_lib for framework install name and linking (can't be done via CMake configure)
    inreplace "src/CMakeLists.txt",
              /^(\s+)(INSTALL_NAME_DIR )("\$\{QCA_LIBRARY_INSTALL_DIR\}")$/,
             "\\1\\2\"#{opt_lib}\""

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qcatool-qt5", "--noprompt", "--newpass=",
                              "key", "make", "rsa", "2048", "test.key"
  end
end

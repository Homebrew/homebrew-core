class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.7/qca-2.3.7.tar.xz"
  sha256 "fee2343b54687d5be3e30fb33ce296ee50ac7ae5e23d7ab725f63ffdf7af3f43"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc817be4986a7d4d17be9ac9db00a8d55c5ac2097f4c801fe4ea7bd24f37854e"
    sha256 cellar: :any,                 arm64_ventura:  "843d60499e572915067992458249f4c281166a0b90ea2bd846d3fa9bde1bb2e0"
    sha256 cellar: :any,                 arm64_monterey: "c03a81927c330ff84817859230f9a706c48ade46df22d07d764840a891eee25d"
    sha256 cellar: :any,                 sonoma:         "4b73a17ee0af0fc560eb48970d8d0e7084544c15ba56737c7c52652f1a1668dc"
    sha256 cellar: :any,                 ventura:        "b0a7a57035929f9bd33e4b999cb419487da776c6e1a2a2fcbb182aa98d53285e"
    sha256 cellar: :any,                 monterey:       "26a7e7ded36e8cbf9c20685acb1e1947a66f3e054a7b18e60fa3e56986a7cc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b627471a9b90d6d17f0659cb41b06693c353ee40b7ddbbe3c3e1b1ed405249d9"
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

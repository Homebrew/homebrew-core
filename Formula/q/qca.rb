class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.9/qca-2.3.9.tar.xz"
  sha256 "c555d5298cdd7b6bafe2b1f96106f30cfa543a23d459d50c8a91eac33c476e4e"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9cc13dd40e5e73cc260cc321fa1d146cd182e45efdae6e19ff83a9cf24bc3c3"
    sha256 cellar: :any,                 arm64_ventura:  "7dd60221007811c08a635b5e5f81b0a8de617740e37d2a8c1edee3787d6dd21c"
    sha256 cellar: :any,                 arm64_monterey: "bd6edab48132b7caa50fc2c188706805aed7ab3f11eb8bd3b37ca45d7c7aa0df"
    sha256 cellar: :any,                 sonoma:         "d564e58a708d2b64ae18041af2cec38fc8db0817df503c84a094c2a2d7d588ea"
    sha256 cellar: :any,                 ventura:        "a9edf6e8f76ec69bd1c12df83bb08bef06a14a244290aaf5c7373a6d81b39151"
    sha256 cellar: :any,                 monterey:       "c97718e6d4f43e7f128e187971a4ea2cb1b9f6d962685587cb0bf45b0f81ed6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95900ac1ac78e1ad9754e25c1d0eb1b79e206289445d932bee87bcb62fb5dc3c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "botan"
  depends_on "ca-certificates"
  depends_on "gnupg"
  depends_on "libgcrypt"
  depends_on "nss"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"
  depends_on "qt"

  uses_from_macos "cyrus-sasl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
    depends_on "nspr"
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    ENV["QC_CERTSTORE_PATH"] = Formula["ca-certificates"].pkgetc/"cert.pem"

    # FIXME: QCA_PLUGINS_INSTALL_DIR should match qt's directory "{share}/qt/plugins";
    # however, building with that directory results in segmentation faults inside
    # PluginInstance destructor at `delete _instance`.
    args = %W[
      -DBUILD_TESTS=OFF
      -DBUILD_WITH_QT6=ON
      -DQCA_PLUGINS_INSTALL_DIR=#{lib}/qt/plugins
    ]

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
    system bin/"qcatool-qt6", "--noprompt", "--newpass=",
                              "key", "make", "rsa", "2048", "test.key"
  end
end

class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.8/qca-2.3.8.tar.xz"
  sha256 "48759ca86a0202461d908ba66134380cc3bb7d20fed3c031b9fc0289796a8264"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "216ca2aef055ba9ce90ec813b8dc039041e90b821e113563ad825879fc60cd17"
    sha256 cellar: :any,                 arm64_ventura:  "bc3767a5578438daa50b649affd0d072f7b3b773142f0b50870517e00d3088b1"
    sha256 cellar: :any,                 arm64_monterey: "1f81f86cd7bd048b243cd251e74020c0f9f9fe38b246ae4dd59fffa819a6e49c"
    sha256 cellar: :any,                 sonoma:         "41c866aa265c7f6a96faa858e1ccf306e4fa1e9e76cbbb4a411a561e8849f799"
    sha256 cellar: :any,                 ventura:        "b65a8e4f2a6e8a67f11e27b6a58e9b3da735de2f0795ff199e3bbda7561f018e"
    sha256 cellar: :any,                 monterey:       "da6412ada84a28846ba1e57dc03bd244ba630e5cc58d7366e209f8bf64af59c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b0c4064e9cdfa23b770c86994bb3b4b2069a1b51ef70e8e9926ae7db0fca2ca"
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

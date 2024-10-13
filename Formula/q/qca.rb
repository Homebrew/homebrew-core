class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.9/qca-2.3.9.tar.xz"
  sha256 "c555d5298cdd7b6bafe2b1f96106f30cfa543a23d459d50c8a91eac33c476e4e"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "adf75807ab0a7ce48899abf875761a9feac73ffffaef48cd45472ba6c560ff3b"
    sha256 cellar: :any,                 arm64_ventura:  "324d59553ffe39978d6e26e0da9670c1586eec9f514f184414b46c1e427395e5"
    sha256 cellar: :any,                 arm64_monterey: "0d2f18ad7e80e54f5a85ff998d67182b361ad2bbe30d7c669034e18f05ad6bb8"
    sha256 cellar: :any,                 sonoma:         "95632a1e2ec25ac1a130a9a1a2048e23a516bfa78a6141a509579e40e0cacacc"
    sha256 cellar: :any,                 ventura:        "9afce1a3de7f842cc8702e8ec15aa3e341be5f722d80589a2db5b6e7da7cea6c"
    sha256 cellar: :any,                 monterey:       "e301832afda20aa57a79543422443102652d54ce16fec8282576b09c39787307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0b4c7ca31b657540b83f7679ccac9c81016386148a1134a5f71387d16dcbb3"
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
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
    depends_on "nspr"
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with gcc: "5"

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang
      ENV.append "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib} -lunwind"
    end

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

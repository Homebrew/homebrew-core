class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.10/qca-2.3.10.tar.xz"
  sha256 "1c5b722da93d559365719226bb121c726ec3c0dc4c67dea34f1e50e4e0d14a02"
  license "LGPL-2.1-or-later"
  revision 4
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "818d341dae76b762accb69b2ce4f4c9c07c58639d82dbeff6b7f1c55fd9e7a66"
    sha256 cellar: :any,                 arm64_sequoia: "b3eb68077400ddb74b629e06466409ee5891e0dc385cbae4da39f4b7e30aa979"
    sha256 cellar: :any,                 arm64_sonoma:  "35373ce735224f22bdfb260586ce6f1aa7a85be8bc63a0e3949d45dc055a3c4c"
    sha256 cellar: :any,                 sonoma:        "05b9faa226a1ffc150cd6ddc6e6d7328725b81413b8e56e0007bfceebe34de47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f5b7027eff968ab96d3eb53db93deb0b1ae3d51d08617abbfc94c689ee0f995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "697e728c265a6852dc25ebd2a87b62a87a6abb4d2f76ae9de6b669b406bf24e8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "botan"
  depends_on "ca-certificates"
  depends_on "gnupg"
  depends_on "libgcrypt"
  depends_on "nss"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"
  depends_on "qt5compat"
  depends_on "qtbase"

  uses_from_macos "cyrus-sasl"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
    depends_on "nspr"
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.append "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib}/unwind -lunwind"
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

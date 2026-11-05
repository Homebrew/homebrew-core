class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.12/qca-2.3.12.tar.xz"
  sha256 "d4a2b3aa0272d73ea0c4cd2140960177fa34ddc2030e59a48ecfb80c757572c3"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ad641ecdad18785111bdb66b1b4640f9d0bb45ef4fca3aea611e9dbc6efce6d8"
    sha256 cellar: :any, arm64_tahoe:       "fe698c5e4735687ade5f2e7c36fa498e7e94037f47463dcae03856a1fdd0d1e1"
    sha256 cellar: :any, arm64_sequoia:     "4bc45847b84e7bf714d0482acb1f8aa5ad81089af94686907ad80bdf9e3f77a6"
    sha256 cellar: :any, arm64_linux:       "79d42fc6eee4d323a65e4192d9acaafde89ada253f0bfe4337823b9b95842f21"
    sha256 cellar: :any, x86_64_linux:      "0b94aa9d5c72f016cf02041e2b9118f8249a2b106a2035347b4e57536d86648a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "botan"
  depends_on "ca-certificates"
  depends_on "gnupg"
  depends_on "libgcrypt"
  depends_on "nss"
  depends_on "openssl@4"
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

  deny_network_access!

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("llvm")}/c++ -L#{formula_opt_lib("llvm")}/unwind -lunwind"
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

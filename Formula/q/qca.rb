class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.9/qca-2.3.9.tar.xz"
  sha256 "c555d5298cdd7b6bafe2b1f96106f30cfa543a23d459d50c8a91eac33c476e4e"
  license "LGPL-2.1-or-later"
  revision 3
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "0f3ead58c85004587db243d689151c0c61eae05b118c3feedda2181f2b505e6a"
    sha256 cellar: :any,                 arm64_ventura: "e7da11ae4f89e160b58bb3c7b80954700c4b2a52838897a5fea181f8bf4d24da"
    sha256 cellar: :any,                 sonoma:        "fc7485d81e7e45d8c9206bd300362aac1c751161be61d8256a502e5f7d9577dd"
    sha256 cellar: :any,                 ventura:       "1b293dcfb8a7792faafcb394cfc27e63c170cbc920caf735ae482f2cb515c82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f044b7ecfbc942523ef7b424f9c2338562a45ea0df2b067a5a1eee764f05b2a"
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

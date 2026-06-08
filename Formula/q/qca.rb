class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.10/qca-2.3.10.tar.xz"
  sha256 "1c5b722da93d559365719226bb121c726ec3c0dc4c67dea34f1e50e4e0d14a02"
  license "LGPL-2.1-or-later"
  revision 5
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4bea07e0d10d689e6d1cedccae2c0bd7c2b5ccb8d13a6b9548f90ce5fd734ae0"
    sha256 cellar: :any,                 arm64_sequoia: "c36105d102c5015030076c38fdc0d42940df1378b4d1c2953c4b16e67704eeda"
    sha256 cellar: :any,                 arm64_sonoma:  "bddd51df7a662b953dcfbd7fd42dea92f50bfbd95fcb7c7330625fa1bb3b1c1b"
    sha256 cellar: :any,                 sonoma:        "1eb3d9c8c5e997ccdbb12ff8ea0aebedabe8e68b09e16c85b652a2eea0ef89aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195c18875bc89c15ce17b8a0e4c6e73b7b57c5e71afafea7f683776d1eddf296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "220cf9d9b004882e4428fb04dae0971a60a5d3db9b947c7fc33976b001ba4f08"
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

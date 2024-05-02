class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.8/qca-2.3.8.tar.xz"
  sha256 "48759ca86a0202461d908ba66134380cc3bb7d20fed3c031b9fc0289796a8264"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ac1bdc66f6ac4c7153b91cdf1dd6526f8a0da87d3c2b9239dd88619d6f77077"
    sha256 cellar: :any,                 arm64_ventura:  "1af6acb759656c3c345c9d54a3c395474b899762bd6f0a1cbd4b3e36db4d8ed8"
    sha256 cellar: :any,                 arm64_monterey: "4fd1f850b3d5ceb078245f0a10c67cc50e5053ac04ef0c49f39fe67d0395f463"
    sha256 cellar: :any,                 sonoma:         "e97e6bb95d11830711d17e1fad1191421daaf691d640ffea3d88d8b8b520f4da"
    sha256 cellar: :any,                 ventura:        "e919ef19be9690235db663071744edc8ef441169d224982ad475f9835e910c59"
    sha256 cellar: :any,                 monterey:       "160a221433d2bf2e86b21ce168812ceb240ae9b2d12801114c13ba8d7842b293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ed3a4bc1916583872a4c8915ec8ab669082cd3e425ac2a3318a2017ea62384a"
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

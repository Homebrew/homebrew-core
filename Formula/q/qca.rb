class Qca < Formula
  desc "Qt Cryptographic Architecture (QCA)"
  homepage "https://userbase.kde.org/QCA"
  url "https://download.kde.org/stable/qca/2.3.8/qca-2.3.8.tar.xz"
  sha256 "48759ca86a0202461d908ba66134380cc3bb7d20fed3c031b9fc0289796a8264"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/libraries/qca.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/qca/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be5c81b8ea7e03cf23979ab7b8922c31213b8c4861a10178b1b092a0c3a5e952"
    sha256 cellar: :any,                 arm64_ventura:  "4a23c095adb5b58e4455a0073beb65a01d7aed68f99ff42e896b13b3dfaf754f"
    sha256 cellar: :any,                 arm64_monterey: "8b1b95d2db586333e330bc7945d53c74a3626787f845d280c9d6a540b0b392b3"
    sha256 cellar: :any,                 sonoma:         "1dec33eb15212833cd68c53c1634130eb756bd084f5013c900f85d642e6737a0"
    sha256 cellar: :any,                 ventura:        "6c2b9563d96b052a3605232e98f32480cf0e53b83a05ea6b39d9cac0020e515c"
    sha256 cellar: :any,                 monterey:       "b0f69af4d530dca5b61712aa6744fe63830dfd2d51bf5f2b3cc6135e5807d0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcce390bf80c101b5c5b6b77d76fabf4db52f77f4e56098e088983bf054f0659"
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

  fails_with gcc: "5"

  def install
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

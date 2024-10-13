class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.13.4-Source.tar.gz"
  sha256 "b26465cefb3f08228d14955b3cff82e2b4c6b62062a33e6d9788e8b5be20b9a6"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "f311d712cc314cd41305eb141cf2eb2cf94d32bdc471733238b73e23b3a1313e"
    sha256                               arm64_ventura:  "d1fb8a666bff6d67c365a8dd8dbf044ddf6a5de971ab698baf5980992143eb2c"
    sha256                               arm64_monterey: "29edc22c1f224a681ae365f2b2c9c6e5539ee49ab246b4e64b2b6c0994c1a89d"
    sha256                               sonoma:         "11101528a682eaa3771051b308e3d040b4a6bd1602b707a0f35504e002ed2817"
    sha256                               ventura:        "5e5d0d8325918a5ca8c8c73f82c9bdf02582ec83451c4d8861ce6c220ef5f46e"
    sha256                               monterey:       "2a78e391b2c02ec18f7767921134f3fc71d0cb58636db3a97077ace11a1464c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "442280672185cda687b25959de7f5026fc5db020a164efe236074a3936c39228"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  uses_from_macos "libxcrypt"

  # requires C++17 compiler to build with Qt
  fails_with gcc: "5"

  def install
    args = %w[
      -DECBUILD_LOG_LEVEL=DEBUG
      -DENABLE_PYTHON=OFF
      -DENABLE_SERVER=OFF
      -DENABLE_SSL=1
      -DENABLE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # current tests assume the existence of ecflow_client, but we may not always supply
  # this in future versions, but for now it's the best test we can do to make sure things
  # are linked properly
  test do
    # check that the binary runs and that it can read its config and picks up the
    # correct version number from it
    binary_version_out = shell_output("#{bin}/ecflow_ui.x --version")
    assert_match @version.to_s, binary_version_out

    help_out = shell_output("#{bin}/ecflow_ui -h")
    assert_match "ecFlowUI", help_out
    assert_match "fontsize", help_out
    assert_match "start with the specified configuration directory", help_out
  end
end

class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://ecflow.readthedocs.io"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.16.0-Source.tar.gz"
  sha256 "666f804473e0bdc63f51e0b74531217c74f6e6ed40a33c11f7d2916918489741"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "79bce7cc72cf7eb4bf1c8e2089fdd3cd97c6c4b0780b7ba01f0a2644e73d1048"
    sha256 arm64_sequoia: "6ba32325148149edd2ad15df2d7ae281d44495391c743cbb79e70d6f8548e165"
    sha256 arm64_sonoma:  "3e9f65e669f805447fc5b3f57b906460b7fcdc36ec515658df27f866936ebfee"
    sha256 sonoma:        "7d261ea2a63aa5fe4bf190334310055b1a0b579bb87967df6dab493a3961703d"
    sha256 arm64_linux:   "603a380e3bd9cbdb07a224f36ab72b0edb1f545f94870b0f58a7544e4059d5ac"
    sha256 x86_64_linux:  "a9d1f88ce53b5ac82283ed7632eab85d1571b2d4becaa0bffd010137288b081f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtcharts"
  depends_on "qtsvg"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

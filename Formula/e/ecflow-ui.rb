class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://ecflow.readthedocs.io"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.19.0-Source.tar.gz"
  sha256 "84c7efe001ff293498d8313440c91f57596cd404d3391c5ed8777888b32e55e7"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "963dba366a8bb903df5a956443e60f0e01d4aab897d82b4cd1bea6009cda6e0e"
    sha256 arm64_tahoe:       "95ed760643ca10144f66856d3dc065ae988a07fc9d51b3e5cd5ceca42c0afbf3"
    sha256 arm64_sequoia:     "3250cb2dc77bb852dcb5e4f1fbcabaab15aea11265210b0f5c9d0300d24153c4"
    sha256 arm64_linux:       "aa4bc47d5f9ad7ca151f31b82746abe0a18d3a69745f3545c598ae79c53b8c3d"
    sha256 x86_64_linux:      "a7a4cc5d8b614f8d8812b7748b7b0549f96e83d6f5312471778c0846e44c1134"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@4"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtcharts"
  depends_on "qtsvg"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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

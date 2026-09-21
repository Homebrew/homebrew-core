class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://ecflow.readthedocs.io"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.19.0-Source.tar.gz"
  sha256 "84c7efe001ff293498d8313440c91f57596cd404d3391c5ed8777888b32e55e7"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "0534e739ad752b3f17300a54eafa133b7e7e2da78ba0132928cb13d10450115a"
    sha256 arm64_tahoe:       "755a920f95db686597539293c9dc223563626d4bb4986020f8e9bafd6a24ad4b"
    sha256 arm64_sequoia:     "6d6c45a7a67faa6c7ff5e02e8ef1d83134367dffb3ab2ed21dade1bdc4266605"
    sha256 arm64_sonoma:      "96b2f62d5460bd9aa2bd7177036d4de29464e5843e098b5518f3fbaf845f35b7"
    sha256 arm64_linux:       "00cee13332701a2f29b4ff345f98309d46edf3404caabec513e3eb06b4f2be9d"
    sha256 x86_64_linux:      "6cd8373e8c0f4b53751b9ae0fe7bec5feb980bd3c52588483e96b34463d18920"
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

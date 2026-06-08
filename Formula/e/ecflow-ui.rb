class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://ecflow.readthedocs.io"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.17.0-Source.tar.gz"
  sha256 "01223d93cc31d976fd955c37a03d4a145cfd27a81db86b5b94878275e94e4ec5"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3f80f7719f07c2f2c303755d4e68ba113c16ccd245cd1bd11681f2f86eb03741"
    sha256 arm64_sequoia: "cd9853436214453d426ff2a10034c32847229c6cb375553d6904c7a42c251fbc"
    sha256 arm64_sonoma:  "9c7c033ecea025b045f4b8ae852abd07d57308bed442958d033e1e06a2e51d40"
    sha256 sonoma:        "c5cbbf0e0a77bc1d6865c3a778e41a1ac1eb5856523f75c29072c24c7a7da718"
    sha256 arm64_linux:   "9b1e30e99481af09b0f327eaa421bfa4779fe8c3c6fbc1ae5f2bd118ca51d5bb"
    sha256 x86_64_linux:  "985415aeac483e3f28bd9d77955ec1b1b4bc2f5c977ba104d536944847ae84f9"
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

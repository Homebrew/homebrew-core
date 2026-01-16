class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.15.2-Source.tar.gz"
  sha256 "6e4738167a17b7a8787e4084183b30bd7170a0d150e85eebedb0cfe46e87d856"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3a2d6944d14d35d8697c41b1896b47d1c92200d78635af09645bd08b9169c852"
    sha256 arm64_sequoia: "c9e2e95dbac66a092105dc3a09e375b93878ac3fac6c63fb55dc2a18a9d94eec"
    sha256 arm64_sonoma:  "299ff590bc226d95352ef2163348f8b79b0c6bdb96ac84fdff87d845f5dbfbf2"
    sha256 sonoma:        "126a9c10588756a2eb999a2a7c52783076357132bcf96ebed3dca7ae7429c84f"
    sha256 arm64_linux:   "65e8ff9d3e04469d9a42b54e0af1a8c6a94b527c307914d28da3ea11eec3cdba"
    sha256 x86_64_linux:  "fd752424e0e1ba3c63117decd5bed7dceb3cf5f109f2efb71a4e6ba236aa34ce"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtcharts"
  depends_on "qtsvg"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

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

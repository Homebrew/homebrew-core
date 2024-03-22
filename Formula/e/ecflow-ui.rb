class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.12.3-Source.tar.gz"
  sha256 "2caaf64bf1e0ced87fd0bf42c2ee3385093420e5c4609ad4117b8251420d1cf0"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "2074c4c7fb2d368a77aa9b8d4c3cf21b395dfda837e607d6f4d98c12cb81f6eb"
    sha256                               arm64_ventura:  "7b863447c992c4871f0eadec65c41181d43ad849f6cb091842e99cc429fc6e2a"
    sha256                               arm64_monterey: "7fde65f33fceff248db752c81764c7529304ea19440e0265e09a259b5bf41df8"
    sha256                               sonoma:         "3f4ad5405ee09dd1f0ba153736856a8ca796868f1e34e7bc2e15acdb78be5292"
    sha256                               ventura:        "340786860a9ef0e1c890cc9c5955c5ebc3f638d7b46bca46a33a0c98557a0ae4"
    sha256                               monterey:       "5a07cb2ca3db765374513ab5ed27f12ca0fd94bc5b729ef03f43e5acbc24e070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c61e596c74db0afee3a9ac3ad2a742570086533fb3970787db1f2f7e3a8ceb4f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

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

    #  check that the startup script runs
    system "#{bin}/ecflow_ui", "-h"
    help_out = shell_output("#{bin}/ecflow_ui -h")
    assert_match "ecFlowUI", help_out
    assert_match "fontsize", help_out
    assert_match "start with the specified configuration directory", help_out
  end
end

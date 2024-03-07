class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.12.1-Source.tar.gz"
  sha256 "bc56c4efa0c599c212ae52c76b25e292a03575fdbd27b36ed99890b70c5957c3"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "128586fb9171f005508ad22620cebb819cdd6c7ede4ce9587cdb41f9c49a0d42"
    sha256                               arm64_ventura:  "adcc89661033ddbb9889782a9186d4d11fc383c47ed54c6c96cecf952cde32cc"
    sha256                               arm64_monterey: "4f360792441e523e7f801271bebb543f627db0b600e6d6d19b30a1bced63675f"
    sha256                               sonoma:         "30ce7538e036d61a6e05309a65014826f4569084b6e57daec61e142c70507fe3"
    sha256                               ventura:        "cf2c4fd532733ed8c40ab09d2e39fe86a41046093ca67dce9038c6eb56c0c842"
    sha256                               monterey:       "923ddd4b148c20095d86895cc350389a35245f348c4a610334d0b4685d43260d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a43cb99f233ebe583b93aea84d39597f7e8075f4f9f647f10ba51cfd7b30a21"
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

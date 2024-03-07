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
    sha256                               arm64_sonoma:   "8e7b74f984080344c907d11b799d236274cfb8d23c59ce3570fc1ea3f1bc550e"
    sha256                               arm64_ventura:  "914d955103f97651cb2fcc90580d7072b989f71e3bb3abdd525fa3e5ce9189ff"
    sha256                               arm64_monterey: "15e603bef95393d7e84fdb00c4d34472bf8f69fd06aba02d0f632333046cc777"
    sha256                               sonoma:         "8de5d5a789676dd3a6021a2061f8807e7e16c25bec78315f043ee6758c01b259"
    sha256                               ventura:        "d4c085a68f52b46ff87152343f92fa868cae4eb3bad73aa647dbf068438e7b8f"
    sha256                               monterey:       "61cef4a77cd7a8544a86db2b136f9abe760f947a1013cd3520c8dcf42c9c99e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54937a2dfeb422073bc78d06651aa904690f236a1734bf0f199ed0b69e1fb894"
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

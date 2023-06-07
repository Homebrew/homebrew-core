class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.11.0-Source.tar.gz"
  sha256 "d18acd93d42f8ccdff9fc3f07d5a9667ff4861e53c40af35de36ce77ab100bb8"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "7b5f30648b60fa21563dbaa926867f4fa560bf2f965b24099b3543365104083a"
    sha256                               arm64_monterey: "2878586322e881e8231286e1443d3948a0a2eda8ca8215101605e4fe943b0a61"
    sha256                               arm64_big_sur:  "8de3b610be831d5868d8d68bfaddfbac93e6e8543daba5f9e82ca0787c95bcd2"
    sha256                               ventura:        "33c59699c83697615518a178e7f886957bde19a96515dc17588ca72391a5d9d9"
    sha256                               monterey:       "8ec4de95774eda12d4123092a6139fbdbe2e955ceb42de73a0773706ab265a6c"
    sha256                               big_sur:        "7ba839b29c0ae547962020e828b67a3cbb930f6fc2b5e521c95e590a78e90299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85438e5ee6b2223102af6db37d08b1a21f00496345bb9894e9d43da068c85c31"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "qt"

  # requires C++17 compiler to build with Qt
  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..",
                      "-DENABLE_SSL=1",
                      "-DENABLE_PYTHON=OFF",
                      "-DECBUILD_LOG_LEVEL=DEBUG",
                      "-DENABLE_SERVER=OFF",
                      *std_cmake_args
      system "make", "install"
    end
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
    assert_match "start with the specified configuraton directory", help_out
  end
end

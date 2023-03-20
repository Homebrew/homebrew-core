class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.10.0-Source.tar.gz"
  sha256 "835b50540fbda7c0a375e1d5bc9d1c51fe229412ba2178682c4cd52e9573043c"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "5e6d4f55314900f77201e34683c8c8728dcd602b209309fe67fcfca43294421a"
    sha256                               arm64_monterey: "3db592a24bf195e1ba64b3f3792719af23bd2bb885bc9aa87d1e18b27538670c"
    sha256                               arm64_big_sur:  "9f630546ce7243cddb601b641fa5ace57c9de42a362727834c45942a7b476dd8"
    sha256                               ventura:        "e502d54254d7bd58bb3ff0691350209a2480bc5c475ce26beec68c70e92a7b57"
    sha256                               monterey:       "770e78a1fdf00418ea9bf21568b97e9d96624a6aeb6226bb3eadfc8ac15b5a84"
    sha256                               big_sur:        "e1a03136b55ed6d1b730609ffd89f912b7468c7730fcfec99c95575fef37225e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a8795f68facf0a972a90c717fe493dcec55a8a201d764054b95a1d1ee7fc26"
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

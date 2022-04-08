class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.8.3-Source.tar.gz"
  sha256 "1d890008414017da578dbd5a95cb1b4d599f01d5a3bb3e0297fe94a87fbd81a6"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "86e6d6883e027f5c3bd6c2bfcae9e7ccab9b65106549f66d8428b9700e4af6bc"
    sha256                               arm64_big_sur:  "ba72b11ed9b1d3f48e05b55b64038848a71faceb938358fd5373ee86881222b9"
    sha256                               monterey:       "43514c728d08c672163f83888ac80816decda1c3ab40bd9072e3295ee2e6f833"
    sha256                               big_sur:        "0743fa962cda76a4f4b2b1ca4d1f7709fd94c548dd934fd0c2c7607fd437b97e"
    sha256                               catalina:       "f4a15c29f3ef85fafbd3570ea5916faf61cf7df4bab5df40db9088c471ccf949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daecd6c25b804a444dc996fb7e6409d429a46df4f971b27d3c6cc25c788ad470"
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

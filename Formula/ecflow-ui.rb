class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.11.0-Source.tar.gz"
  sha256 "d18acd93d42f8ccdff9fc3f07d5a9667ff4861e53c40af35de36ce77ab100bb8"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "176f0ea869b4f49cb95c65c97abad6c012759331774c7dbc5c0b06985b109a1e"
    sha256                               arm64_monterey: "47055f6b23ab30b05f91d23d9024ce2ecd98f01d8d3d0fdbefc51259d5c4a68d"
    sha256                               arm64_big_sur:  "e402eafb5b13759796863d13d0c14d6f62a30cd0f1ab735fbd3d89f7fdb1705b"
    sha256                               ventura:        "d87caf4ac7293d6cb705a245d162652a2a04627d477d8c8d755747224f5bf234"
    sha256                               monterey:       "8a97bad509b615a56c9732e075bea11a1b7a8d374b46a2bb22f11e09c3c17043"
    sha256                               big_sur:        "89d1ede97daa14910828d4cbe4b4f9a520229d54d3457abae365cd99a2ffe233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f74a9408d4d345c6fa29e8eb0326f4ea154beff494fe5366fde78b7c5da4952"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
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

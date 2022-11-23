class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.9.1-Source.tar.gz"
  sha256 "40f09a4a3d4dfbd1081aabf3dd0c949d394455c6989820ee469d4328f2d57af1"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "ec7de105accd483779ab8a5e6c0883befb41331a30a3a41e499fd70494b3c082"
    sha256                               arm64_monterey: "6ae1e4af4d37930f8b3f9f2ac9eee1b21ce144f3ef3df8668d4a16d585e8dd41"
    sha256                               arm64_big_sur:  "b390efe842995399d306f2b2b3a80b6208129d01a4572172997ebaea899e514d"
    sha256                               ventura:        "1556ad699b95553e2c25edc641e5d15832b1656ade27f761e43fed9d9115d9fa"
    sha256                               monterey:       "eb02666119c06fc883ae3259c003cdc29b7c15bc4fd35215f926e7a05c0ced38"
    sha256                               big_sur:        "71d788e687f913a6679a9ab86048bd34001a955780917670299c002cc1986c01"
    sha256                               catalina:       "6fe63e6d15f115811414b11a7adc75c95c6a34ac1a14ec02b298e7d0ba6a9f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b39d53e2aec7fbc02b39bbffbc361b2a8d0753aeabde1061ce44ab2429a568c0"
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

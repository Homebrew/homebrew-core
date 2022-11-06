class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.9.0-Source.tar.gz"
  sha256 "20c1f457a21aebf7c49f06a4709a6216c6a92ca1899caa2c27d1aab4df53cacd"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "5cb33b2f65bd49224c67236229811b87fa545fc2549fee4fb7de11efc5b763b0"
    sha256                               arm64_monterey: "34174ca9ec67da579c66ccf9c0267d8249547c07b22ebd3f80b7fd20493600c0"
    sha256                               arm64_big_sur:  "07ca8328acfded316b3e9f075920499014f3b3d5ad42e65afde8d8d03525d2cb"
    sha256                               monterey:       "010b85c0f5fa94624b73adb434af5999b0ad2af58bdaba5908c06a30269ff919"
    sha256                               big_sur:        "4321e11694208feb2d9961d88a7b414de7d98625e2058565733e78cc48b2b3a7"
    sha256                               catalina:       "70cd93fe06ebbd720e26064d084a7399c97741b37111998b26278882b177641e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2cc34b1dd4a9f2d8e1a29acfcab7fcd9077d40a10933dd0975185b96b1f107"
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

class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.8.4-Source.tar.gz"
  sha256 "bc628556f8458c269a309e4c3b8d5a807fae7dfd415e27416fe9a3f544f88951"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "4efd58a212460acd12d6a63e6bed76c639dc0610e13fc9e51dc96c93795292fc"
    sha256                               arm64_big_sur:  "956e6e7f868bfb1749649deeb92d2f8a9e2ed51221a2450d7766fc5ca66991da"
    sha256                               monterey:       "95f6398877a20b073daddb32a49bb19a7d83293339b2251f4db31ea091281877"
    sha256                               big_sur:        "725dca63579c61e63c7f09a08af579e9069565cadc15a49ecb2318fbb3019483"
    sha256                               catalina:       "e592ad1ce1f86b8777420ebaccfdfd44d7d7518f2bec209fec629a704a474754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d367ac3a213b88c7331e759b56a053207d06646799a137e69732d443ac9bd6"
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

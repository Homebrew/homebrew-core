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
    sha256                               arm64_sonoma:   "110c6ecf7ccff1ec454794f198248a0e69bb872f21b177b54792400d71778564"
    sha256                               arm64_ventura:  "94cf8935bdf5519500329a36adabb92a413560f368715a112140020cc44ff89c"
    sha256                               arm64_monterey: "55260244eff3a7c51cd267020e03fe29eeed3015df07a3cb6532b328978132d3"
    sha256                               sonoma:         "941ebf9e5c071e3df3b846beec9507cf9996814d6a5d12a7de1ab079c48816eb"
    sha256                               ventura:        "7d16173027478ca8193c7c82c98efdd74f6798649761a65865a8ca7f8a61e426"
    sha256                               monterey:       "9195bc7da6f96a614b46bcf641c0253955d449bb89ebe6bb9bb51f099aeed650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29483ddce511bf487e263e20aa50b19c2c9c2b9f601bad89d5244be47d191905"
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

class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.13.6-Source.tar.gz"
  sha256 "11e1b693fc8f6aa834fc5a9c34503573f6391464b1c21d5023e4726c79aa9df1"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:  "5cea0da653c4f51a1a40c3c4a87e8a79453a8224bfea852c66a2478a94c7ddbe"
    sha256                               arm64_ventura: "54e181a33f933ae8ca641edff650a804148d4decb2c14ebb850f874b008ba144"
    sha256                               sonoma:        "72bd7cb64583c05ebccd391e64cfc855e9f0c2a9860485e5984683802168d246"
    sha256                               ventura:       "d3233263a300ef529c24b4b9b98264aab54577be3f56b67b9c15afcf8f0734c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b3a2bffe503c59c19d8f14f030257e4585a83c100b5b09a856da28a3cfa111"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  uses_from_macos "libxcrypt"

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

    help_out = shell_output("#{bin}/ecflow_ui -h")
    assert_match "ecFlowUI", help_out
    assert_match "fontsize", help_out
    assert_match "start with the specified configuration directory", help_out
  end
end

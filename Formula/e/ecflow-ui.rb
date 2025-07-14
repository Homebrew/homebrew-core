class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.14.0-Source.tar.gz"
  sha256 "ce80f12a0295d44c185b638763142ed26be06ee72c18a66f785182802e1ee7fd"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:  "2b34cf1eb40b63c8f1ddb33075869b15e150d1aee5926cf421841c3b5efe72c2"
    sha256                               arm64_ventura: "337987a7e7b64b63a43c4a545a246ffa4cdd452a7d792ae98fb7f25c0973a17d"
    sha256                               sonoma:        "7e463b5f55dea51d8d4c377949fe74b35c42f3739ccc69aa1fdd192cf2ecea2b"
    sha256                               ventura:       "29ad4d4553da00e28b3cf446427d889834ec6f99c7c44b6eb7eb26523e317eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c36561a9690c2cd519c998df2bdce6416a329b41e63edbe7133d2bf0bee6e6e4"
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

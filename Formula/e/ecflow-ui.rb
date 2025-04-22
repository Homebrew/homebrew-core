class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.13.8-Source.tar.gz"
  sha256 "9d61e463e6f076d57ed6d44c79a865e0e080857cee7a91befcabc3c12a8fcf13"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:  "2a5fc93133a9f1e4ae9589fa08a3388c81976e0bbbb826159521f4879d15b97c"
    sha256                               arm64_ventura: "74fa25efbbe69e5f2dfeac4a84a795cd7ed25292b7bac935af7f5c00c4a04f69"
    sha256                               sonoma:        "38f610c0932a0d4920d0ab1a234a1f51157131d9f45e8e48fcd876ec99246329"
    sha256                               ventura:       "97361cd5fcda1bdc13924de64bd711a26e4b693c84128fd97e9f82b47b998d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6b3756be6cd5b323a7ab077218bb418315ff79d954ba8827803248a12218117"
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

class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.15.0-Source.tar.gz"
  sha256 "326ea7dbe436f9435c51616fc3e611f69efc55ae0e0e32c4ded25cfefe9b05fd"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:  "f938b65073fa519e972cbd848b573138cd38a1bf1be64ba052b6790292cf29fc"
    sha256                               arm64_ventura: "3003b3a4c2fdcbed612f61ef35258b7d6fdf351a89d741f1ec65cee079a6492b"
    sha256                               sonoma:        "ddb4ca5825be94efb9a6a882bb93c2c1bb96ef18280fc0e785406dd53ce756c9"
    sha256                               ventura:       "4750ee72a89f7f2b6c42bb9bd0f874cb90e1c460f656b4a8adbcff2873048852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b15e4f3da6d0672a121e96fa26603b1aabfb7ae54803db1652eff912c3dfb9c"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  uses_from_macos "libxcrypt"

  # Replace boost::asio::deadline_timer since it was removed in Boost 1.89.0
  patch do
    url "https://raw.githubusercontent.com/ecmwf/ecflow/57ef9c0a48d6651a9cf5ceedf4e73b555eed23bf/releng/brew/patches/5.15.0.patch"
    sha256 "87c53a3cc96a36a00589ff0ea3bc44b62e56dd4539fda81155d72b5cf84db2a3"
  end

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

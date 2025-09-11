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
    sha256                               arm64_sonoma:  "abe84ab9bd23b8d40f809b66d2c772059bffef65d045e4da3bba6c72e5ee2d64"
    sha256                               arm64_ventura: "0748a2b33efe71d59065ac0dd9a324c8dba3c6782e1df88195afbd213d46d865"
    sha256                               sonoma:        "63ea7094c1143922888259b352c45749dc4978cbe93c19aec878e439edf407f1"
    sha256                               ventura:       "a9a9773aa61c7e91deceac2a01684d51e952d452e52a6a8b563c21445635b0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b204d26b9127a65095262c473e9b5c23c05d70d6d3334d91932276c84263cb55"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  uses_from_macos "libxcrypt"

  # Replace boost::asio::deadline_timer since it was removed in Boost 1.89.0
  patch do
    url "https://raw.githubusercontent.com/ecmwf/ecflow/refs/heads/brew/patch-5.15.0/releng/brew/patches/5.15.0.patch"
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

class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.15.2-Source.tar.gz"
  sha256 "6e4738167a17b7a8787e4084183b30bd7170a0d150e85eebedb0cfe46e87d856"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "783124d237f7b07ea06fe5cd6828b69021ecce5185da4e69b48d6036474d9ea8"
    sha256 arm64_sequoia: "a3eca041366c2c0a67044546845bffdbbdd30bd7759c7cc376285767bca93d41"
    sha256 arm64_sonoma:  "5ad1d3f03ae80e3514a6fd88090025ab3b43c687a489dd76cd69c468ba910497"
    sha256 sonoma:        "8be431024d8129fa85dfe0ec28ece627fbf2ffc79f96f78de9ef666e52cfb605"
    sha256 arm64_linux:   "5e38a93221cfdac076a961880a7727a8f75a06e549dfdd7a544b17c5e71ece3a"
    sha256 x86_64_linux:  "6893632beaf5b01f0959efea3f36c6d321b7cb250d0fc821623c80888d438cb7"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtcharts"
  depends_on "qtsvg"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
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

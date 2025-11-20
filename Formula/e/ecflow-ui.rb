class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.15.1-Source.tar.gz"
  sha256 "e46293c32545c0182a1989ba5dbe667d32042f592d5bb20d0117c37f08ae2403"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0c667833267b1b54372d7c0e5f8a2e35051ef943d9758adccdfce74c0ab78a4d"
    sha256 arm64_sequoia: "e3f29f83faa4eb7c787d58e3418bfd9c39bed8f736d191e8e19deb36861343ab"
    sha256 arm64_sonoma:  "b3c30e1018158297381c5c9e87b28b60161bde0927a407887a3ec1244f7e8d73"
    sha256 sonoma:        "872ebdd0b116632682f2b2b16d8f9cb85ca0d56984c000a6ff8a847184e24221"
    sha256 arm64_linux:   "63da6cd05bba56dae90331c10f5b75f2a6fae18994359b64a9f13f7305c745ec"
    sha256 x86_64_linux:  "d707e69a3f202787d69239a44af7e0ad355325501e20a706de06748f02b59c21"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtcharts"
  depends_on "qtsvg"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

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

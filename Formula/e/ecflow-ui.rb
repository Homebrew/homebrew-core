class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://ecflow.readthedocs.io"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.18.0-Source.tar.gz"
  sha256 "f01826a442671575a5079bc8c57abaf079317e5c14fe45bdc5acbfe24b8bc4b5"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "64c9033f5efa05ab6f3cc6c9dccec3cc670944a747393dae6217b210eaa0d04c"
    sha256 arm64_sequoia: "0b1d540ad1eb7c833dddb5ebbf945685f58ecf9d1fb513432ec580333a226af1"
    sha256 arm64_sonoma:  "4d4af797eee6d9726a90ca04cf655663fce35d3ee6d3412096f53d5077492c96"
    sha256 sonoma:        "2da3f2096d626d793b508411e706c1ff421a11b51d35387dc4b9ed0481ca0526"
    sha256 arm64_linux:   "a810150bd544ca297c68f0c5a0fbe1aec7b76e01dcadfb8415aa3e1295c1fcad"
    sha256 x86_64_linux:  "4a3512391bc70e79eb24f185b60a1a52c983e70ebf34ec62e647937180910380"
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

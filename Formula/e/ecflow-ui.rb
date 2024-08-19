class EcflowUi < Formula
  desc "User interface for client/server workflow package"
  homepage "https://confluence.ecmwf.int/display/ECFLOW"
  url "https://confluence.ecmwf.int/download/attachments/8650755/ecFlow-5.13.3-Source.tar.gz"
  sha256 "a9ca7f032b8bd67e97d571d72ae1e24c8535bc6722af5f3357890e191a2c395b"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECFLOW/Releases"
    regex(/href=.*?ecFlow[._-]v?(\d+(?:\.\d+)+)[._-]Source\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "994fb3de9f302eea9ba4faba568dbed59a92fc7055e7f295a86512a2a569988e"
    sha256                               arm64_ventura:  "472d25c86e97cfeff8a87bfdb1112c7940b0c99b2d666a805ed450a75db11772"
    sha256                               arm64_monterey: "fb31e7ff923466415a4ec65d696788ed1c8e8d294450b4c38e9e0e5e57f9790c"
    sha256                               sonoma:         "1675d8485b8876c252f11186a118cfe145ee361531d1342cf2f2b41a402de9a5"
    sha256                               ventura:        "5449f3817a26bd050d8aeceea94852a8daa17aee2f2e7330791638430be4d7b8"
    sha256                               monterey:       "120cf10d415f5f7c6b1a71a081d09714f04c36d14b2f80b579a65cdc51925991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077d0d4a27d44957b5210e83f4f90a4477d1639dbe41530c00283a468861fd57"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "qt"

  uses_from_macos "libxcrypt"

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

    help_out = shell_output("#{bin}/ecflow_ui -h")
    assert_match "ecFlowUI", help_out
    assert_match "fontsize", help_out
    assert_match "start with the specified configuration directory", help_out
  end
end

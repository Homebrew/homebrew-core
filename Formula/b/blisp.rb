class Blisp < Formula
  desc "ISP tool & library for Bouffalo Labs RISC-V Microcontrollers and SoCs"
  homepage "https://github.com/pine64/blisp"
  url "https://github.com/pine64/blisp/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "79f87fbbb66f1d9ddf250cdc15dc16638d95e0905665003b08920a4b1fda9f96"
  license "MIT"
  revision 1
  head "https://github.com/pine64/blisp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b3ac4526e3d5b4976bfa347dbf8fb4c2050c1cafda73cecf53d13becec5ad3b"
    sha256 cellar: :any,                 arm64_sequoia: "2c907746d0ed584ef5b384fe5807e6a5b630a12a9e76730b937c936de354bec6"
    sha256 cellar: :any,                 arm64_sonoma:  "09eb4602269062dfbd6fe95eb6a5e3af59f68c855a8f8b9348843f3cf4c78ade"
    sha256 cellar: :any,                 sonoma:        "c3cfa32d909c0388870fc62c0cb15694134762f6cbd1009b5883de7c1213408b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b53d6fcac18f5378f08e26e822ca3bf6522eced20476180cb426ffb4ce94690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d705101f8ca10303654bd4ae6e59e34763debb3e66736699a1c7885ae0100804"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "argtable3"
  depends_on "libserialport"

  def install
    args = %w[
      -DBLISP_USE_SYSTEM_LIBRARIES=ON
      -DBLISP_BUILD_CLI=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # workaround for fixing the header installations,
    # should be fixed with a new release, https://github.com/pine64/blisp/issues/67
    include.install Dir[lib/"blisp*.h"]
  end

  test do
    output = shell_output("#{bin}/blisp write -c bl70x --reset Pinecilv2_EN.bin 2>&1", 11)
    assert_match "Input firmware not found: Pinecilv2_EN.bin", output

    assert_match version.to_s, shell_output("#{bin}/blisp --version")
  end
end

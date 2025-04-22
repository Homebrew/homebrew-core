class Blisp < Formula
  desc "ISP tool & library for Bouffalo Labs RISC-V Microcontrollers and SoCs"
  homepage "https://github.com/pine64/blisp"
  url "https://github.com/pine64/blisp/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "288a8165f7dce604657f79ee8eea895cc2fa4e4676de5df9853177defd77cf78"
  license "MIT"
  head "https://github.com/pine64/blisp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41b508789c6bce007f07aaa0c76f46dbfba9a02e1fdf2a5920985affce135519"
    sha256 cellar: :any,                 arm64_sonoma:  "378b9e0bf8a8de264749eb7f5b45ca41b6606363854cea6e61fbad3b7ef0d865"
    sha256 cellar: :any,                 arm64_ventura: "5fcae89834fc473691f68efb1d465286ebf9286367709eff247e28ecc0898e18"
    sha256 cellar: :any,                 sonoma:        "1b58e07e26693499bf1364127f5bc68c735a38953087319d4f5daf236071c778"
    sha256 cellar: :any,                 ventura:       "7e442f53b23b4c1c216fc5a91e4ef6f9a09dffddd00601f9664bd5cca83bdee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b361198695ac6822882d99ae26212b3e9ca7cf5c19c13e311ab79b3073d3a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a4ed852cd606d9477c96a101081eee8e928a14ca30c24dab41e293b90512278"
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
    output = shell_output("#{bin}/blisp write -c bl70x --reset Pinecilv2_EN.bin 2>&1", 3)
    assert_match "Device not found", output

    assert_match version.to_s, shell_output("#{bin}/blisp --version")
  end
end

class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.65.1.tar.gz"
  sha256 "d4cf3b19593fc7876b23741e8ca7c48e0043679cec393fe24b138c3f1ffd6254"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "260a27a3ecbcab5432a74452634f82e8ee79b2c9ae278e84bcd4e8df47906582"
    sha256 cellar: :any,                 arm64_sequoia: "1c20d5a76631907f3a0d1b12b203f6845e6e13303419779762aabbfb4fcd8abc"
    sha256 cellar: :any,                 arm64_sonoma:  "d3c865608df7e3c24b0116801d2918fdbe591d889c704c0ad005c64aed883b17"
    sha256 cellar: :any,                 sonoma:        "f34b39474905a9f05f5aa5fe527fe9ff5827755b4c8b9bee40b529b40f38b267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5a2299f3e68c76ed040611f5bfe6b45e8312096421490af12adf881bc411191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf20b8adb5c04f04b8df5466f8b738623d036810288c06c5158b9385dcf22b9f"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "perl"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_BINDIR=bin
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "cmake", "--build", "build", "--target", "jitterentropy" }

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    output = shell_output("#{bin}/bssl sha256sum testfile.txt")
    assert_match expected_checksum, output
  end
end

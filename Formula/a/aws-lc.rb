class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "04d9aa258641265099a3b1fbd37a21866e942943e16619087bf79c0b6e08f64e"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5b893c917d4dbd80aee4db0a863e0ca54a72ab3d91b25c23e58f7194359f625f"
    sha256 cellar: :any, arm64_sequoia: "9e0267353f2aaed23da3cafc61f733544f20ebea1e0b35e765406b3cb2f0c913"
    sha256 cellar: :any, arm64_sonoma:  "50e4cc6e9c0357d46f8836116b25b26dfa3160b5aecd0d69674934a267601bde"
    sha256 cellar: :any, arm64_linux:   "66d1467ffce6b04db3ddf903825bff196cf38da41d20bbe166b702f8c9b00811"
    sha256 cellar: :any, x86_64_linux:  "a5c4617a7beaab49de6378b26821ea4840d8e85ddcead066e973ddbadf9c5cd3"
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

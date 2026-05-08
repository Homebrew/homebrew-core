class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.72.1.tar.gz"
  sha256 "7ea49769625a20b7e21230be3692286877473cc075f214ce28231d427e2e757e"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed0be2b0692aca3e894d116bfe81c2d5bb62de5410d1eda4ac5df74932e93625"
    sha256 cellar: :any,                 arm64_sequoia: "eab0f74568e414136f46898a12a9bb1623306b7d2a0c0b501fc39a47681f96d9"
    sha256 cellar: :any,                 arm64_sonoma:  "f80a5d9d52ed8dde97278f6b200e025282a0aeae8a5d5f314c59e42c46d443bd"
    sha256 cellar: :any,                 sonoma:        "de30b6201c503e9b2eab95c5d5f19eac81c12c7ecc98d4011ecd35b678f782b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "312d147821947e5b3bda5ce26bc451a613e80f51b4ca60609592d9f86ac48e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559244d9d0259da9ecd290c0b21e642384b85dc63632648ea9ec412c00b307aa"
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

class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "c5c6cc7dea4c08300fb139272eb6fcc259918dab37587db8b6631c75830dbc0c"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2f8875bef06df439e9904903665fffdccaf99b93ff4dfe6d67e56308cdd5f4f"
    sha256 cellar: :any,                 arm64_sequoia: "9ff4316d3b6f8a6e296123a0d0be5ae624d5550ebc69573f8da4c2145c75191b"
    sha256 cellar: :any,                 arm64_sonoma:  "5dd030baaa313c3c996a10a654ee15c6e684ab0506ce4f6ae37c90dde305b145"
    sha256 cellar: :any,                 sonoma:        "a59481be8c68f2ca63bb7602aabccfa4455d92fb7b8a78d1f9a26f84e561f25b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1daadf36857424b32087b8a834e9746677238e982cec9dbdc83d0e7ab878c040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186a306b7d409cb9b206bcecb357e165dae50b82268f4f09d808d01d3a8eb5d6"
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

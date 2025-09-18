class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.61.1.tar.gz"
  sha256 "d9112d79d4c22a65725100de5dc933835320c09dbe008cfc03faf96807b1ad45"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f20a36ab2c09b66871e029993c54aae5571b02ca35b2e0862130c86653bee640"
    sha256 cellar: :any,                 arm64_sequoia: "65d820c91ac1e6a75d692d03a7fb1d4acd44360d0cd3154ee6d434a0d417e058"
    sha256 cellar: :any,                 arm64_sonoma:  "0fecdcc37bd5601ec738dbbedda48fc190d5cd99a27b0e2cdecd4eb4a2dbba9f"
    sha256 cellar: :any,                 sonoma:        "bc4e49a1a84cec576f1ada7b5bd76d7a63668a9f08a7268d731d86d9160248b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f54c9f432cdba4de708668e1432f9d87ba2c9603025c7068f7b84e1b732cea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "829c212fed7d72ce5404ea24c24e75b16282a6f1a8a1f3bd0df5adbbdb506d25"
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

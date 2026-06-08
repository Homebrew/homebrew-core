class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "b4e1ea639d526c54243b8fbd9d21e101360423965bca5cbd72b862e7c9efdb12"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5e1a9718056e72daa7fe889bfa06797eacbbbabdafcccd9c7f7c8d1df566ad21"
    sha256 cellar: :any, arm64_sequoia: "02ecb717ab3a33e38742232e23e43745c79d93ec0112e07aad2f7bb39bfcd8f2"
    sha256 cellar: :any, arm64_sonoma:  "3ee88c1ea43780dcd55466593a9dee9559b839e2076216b64ec74dc796700ca1"
    sha256 cellar: :any, sonoma:        "0d3b2e1b2476509dcda41ea2c1cf538af496b3cfc2a32552b5398963909003e5"
    sha256 cellar: :any, arm64_linux:   "50efb2839bdacd8468bf3fbfc56b60240618c70fceb879886243fcc82de94b2b"
    sha256 cellar: :any, x86_64_linux:  "aadc156db6980cba6649074b6a0fd7601d7d05f532cde21f22ae14d2998230ca"
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

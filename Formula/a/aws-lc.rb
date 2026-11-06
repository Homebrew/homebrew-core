class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v5.13.0.tar.gz"
  sha256 "36169f60b2fd0619d919ac2e76da6b7912262256b93908f5c702a4c1b6c9b110"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "668ad72ec567395fc218020f572e5b283cf88c82cc569babdc586a74da400d49"
    sha256 cellar: :any, arm64_tahoe:       "bee75f45559b1ac28d7054da3532120fe025b2af24c5815e0f8edb89653c5221"
    sha256 cellar: :any, arm64_sequoia:     "40d5e30e33bd6e2396943d19fe12a429824013cfc93c4ede7d257c9d2e8d1b65"
    sha256 cellar: :any, arm64_linux:       "6ca600a365d1e46aab59ed05786c9d9a10183be0c0b7eb0b65bb92b1f692f425"
    sha256 cellar: :any, x86_64_linux:      "d8c47ba6de755a842a5584fe3d832577adf616ec750e3dcc8a83e6a6a03a3629"
  end

  depends_on "bindgen" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "perl" => :build

  on_macos do
    keg_only "it conflicts with OpenSSL"
  end

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGENERATE_RUST_BINDINGS=ON
    ]
    # Build with ENABLE_DIST_PKG to avoid conflicting with OpenSSL symbols and files,
    # https://github.com/aws/aws-lc/blob/main/BUILDING.md#distribution-packaging-mode
    args << "-DENABLE_DIST_PKG=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # The jitter entropy collector must be built without optimisations
    ENV.O0 { system "cmake", "--build", "build", "--target", "jitterentropy" }

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    bssl = OS.mac? ? "bssl" : "aws-lc-bssl"
    output = shell_output("#{bin/bssl} sha256sum testfile.txt")
    assert_match expected_checksum, output
  end
end

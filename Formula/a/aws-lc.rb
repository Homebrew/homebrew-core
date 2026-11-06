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
    sha256 cellar: :any, arm64_golden_gate: "b235a7ce713b0c3d04a9ae8c9c84a44af45136e1ece2e40b5f197e04ee4e3587"
    sha256 cellar: :any, arm64_tahoe:       "4fda303ca143b825a69303dd849d05aab1a29948bcd41301bee8e18dc535e207"
    sha256 cellar: :any, arm64_sequoia:     "21680ef59b05047c4baa7a0edfcba968b9af225875c45cbfdf8dbd4597fbc83c"
    sha256 cellar: :any, arm64_linux:       "82dbc7c5b587d29317ad55694fb2e3805c305ca86f00d00fea8c85aa314031f8"
    sha256 cellar: :any, x86_64_linux:      "caa3828b5ba74869badbb85b1de42921a81c1e49f2618ecebad1e9b6a643fcb6"
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

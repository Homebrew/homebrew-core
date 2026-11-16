class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v5.15.0.tar.gz"
  sha256 "66e7132566cf2356b16ae79a9b57ea7a75ad6d65a41408753b08569c7db02921"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "59632bccc84feabde9759d332b5679143b343b1df281ab06a8bc508a9bacbc32"
    sha256 cellar: :any, arm64_tahoe:       "355e1f40ea38f5f42a8131be28e02cd1a36d119c8c0e2994125c3ce56f890bbf"
    sha256 cellar: :any, arm64_sequoia:     "f8384ef6d3e74a99ef2e483f58bd1d89ef9c00bbfaa7aa6b1ebb44799f8549da"
    sha256 cellar: :any, arm64_linux:       "c9624ca564a58725fce40582b0879d83dcabffd5830dfa127aa35b7c77ae6d43"
    sha256 cellar: :any, x86_64_linux:      "42123fdac2be3b76ebbd4ac4be73b5117a07d3d195fd109fce575c65de4d2f93"
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

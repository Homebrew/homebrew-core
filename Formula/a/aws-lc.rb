class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.61.3.tar.gz"
  sha256 "77a48f7cc33fd9712d89b28335933c329946665a8cee8ed91c47b9594db64090"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1124870912b5a74e75088114749012d27d3188fc0f1c835697dd148f3e87d0ea"
    sha256 cellar: :any,                 arm64_sequoia: "c86d2053241fa4f0a325e2c4016c8b8f4fb156a7957d4fb907c1caece2cca9ec"
    sha256 cellar: :any,                 arm64_sonoma:  "7d4a93760146347a3b7f0f49abf8ad7ad2f2473b392d0a6453090b4e356941de"
    sha256 cellar: :any,                 sonoma:        "24e8b6140b812dbedfd381d33935a3840f194134e819607c794881e5be1c77d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37cc2d5149ab59315929448b30ce9f75007010b12ba287abf6cf743b0da7aeed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4016d33499093294c206a387aa03b6445f267a85e4df6f77819f8e95003a06bc"
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

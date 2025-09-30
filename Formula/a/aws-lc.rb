class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.61.4.tar.gz"
  sha256 "443b62dbb51bb4ce1ce16150fa555da4182e3ba4c928f57f74eb07097138893c"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c17ff8c17ed6f238f665c7cd616c95005b0424761d33decaec0be3a15e8734c"
    sha256 cellar: :any,                 arm64_sequoia: "c7dccec8378eb4a09aa0d388a708937eea69eb9e31e7668047a394b62b6374d6"
    sha256 cellar: :any,                 arm64_sonoma:  "e7eb9a6090d4526da9d607590e32c6ff442d9452ed4fd9990f90ba863345a353"
    sha256 cellar: :any,                 sonoma:        "d634a5e47c54ff83d2d26be11dccdcfc7607f82bfdd51266ecba985cf78dd62b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c64d5a0f218f69a7d72a95d9797e6aa1dce2bdff19469cab2e8db8536f092b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19d34beb787476e7c938aeaf2c479293b645e1b7ce333dcb55be8b4917575c3e"
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

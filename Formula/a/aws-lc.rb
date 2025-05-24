class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "f8e948a23eba174cc5cd07f86983bace3828cc870214d3a4d1ea7111112394e4"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ab5f6de511aba27d2a98f53cadce543ea0a1278c496ce87c594769699ac348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71871e43ee0cef6ec703e25ecbad13476174b9acc556e78adeee83e7b02845f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f373de0b10f182fd87ca4c462bf8d04d6a314f705f0c1be8bc22da214c9d091"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f30b6dc0c3d315207a21aa6ec600a1ca9c4354a37f21fc105fcae454ee8f85"
    sha256 cellar: :any_skip_relocation, ventura:       "6288987d3f9df3ecdd3d91337c4368fd2c37485721345c11c180037010915539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c5f8ee6dcd133db7e2c517c79044118ba19ca8ac7e31114f0cb6b8fb6bbc64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf56421c33080a4388a596d1b548cc8b97289079056d49bf289b1d6a64530f66"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "cmake" => :build
  depends_on "go" => :build

  uses_from_macos "perl"

  def install
    args = %w[
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DCMAKE_INSTALL_BINDIR=bin
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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

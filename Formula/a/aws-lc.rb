class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.67.0.tar.gz"
  sha256 "e592fc107d2376cc820b01b394f718cc1ef2ab92f12a4960a2294c621bc5df66"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8f96c29dc3a8dd3bc4e140afc6fc8ad277c845f82c3d7c54c58ea6d3936c995"
    sha256 cellar: :any,                 arm64_sequoia: "2d4986a0a2f95e51dada0e88235c831f29e5a87fd296307dca3aa3ed2a54e55a"
    sha256 cellar: :any,                 arm64_sonoma:  "990f4c41a9efc710e5f559cdfda6ccda2d4ac81c138b189e7e99bd6904a12b23"
    sha256 cellar: :any,                 sonoma:        "a75b38f376fb04e76c602c0a7e543ff8c1215a615c131f29929011d1eb75b876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d084523ad59606ab0fb9a812e24b240cab55f473905a227feb02b575444ce8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4757066af8adc282f46f068859e72804a7374cbf5a99d9b504576b6343af7b5"
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

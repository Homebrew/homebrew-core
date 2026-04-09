class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "31b1eed775294825f084c0d4e09df53e1cf036fb98a202a8c2c342543828a985"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c71f387ccf9fa62b27218be856a4a5a1504d23645722d94eb7d6f94a627edee"
    sha256 cellar: :any,                 arm64_sequoia: "9c3aedf2de1f31eb2d9fbea1d723f5df76108ec6166cd0a79e2f8ec218dd245c"
    sha256 cellar: :any,                 arm64_sonoma:  "a90b0339eab5886683898dd5556996aef036e7c93997b5ad86a1895f49f72aef"
    sha256 cellar: :any,                 sonoma:        "549e00e4577ba9a218cfc3bc3bf94473c31f094287decd80af419148b3481eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a31c143d266e031e2a58f123f6df538275ece368e13bd39fb12f1f6cde77cbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e12989368160dd9bb810c47258dd5666bf9c745c27c59f32dc2d66aa11c056a"
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

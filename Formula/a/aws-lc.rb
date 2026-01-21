class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.66.2.tar.gz"
  sha256 "d64a46b4f75fa5362da412f1e96ff5b77eed76b3a95685651f81a558c5c9e126"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6cfa4b90d699c03c5cd8ab52bde419abf97da795fb393568f1fa21db4cdbba9"
    sha256 cellar: :any,                 arm64_sequoia: "e638c1554bb87cd794f99bf816603c6fbdc9e54bea508f41b125d06e278fd2e4"
    sha256 cellar: :any,                 arm64_sonoma:  "0c06cfa7db2aaaa492a818dbc24ea2559a7048d73df7dde952f308164f6df51c"
    sha256 cellar: :any,                 sonoma:        "11d80ecd07eb40d405b4a8455efd28351fd255a00d26d523bc5f7548a3cce0e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c54c7bcfb0dfc468ba85528414d979a7f42aab888d60f854918f801d363dc096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5947bfd7308322c5b4817af7a0731713c8e0ea305ea9cc506b0316a06b38cf40"
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

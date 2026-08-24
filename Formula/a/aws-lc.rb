class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "d79a5beb1c2f7fd86a17d91eb230ae12da71dc28bedeb775c179863cf279c650"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aa3e77a4af00f917240ed7dda38790adfec6a2f87d8649c887464fd1f61c75d7"
    sha256 cellar: :any, arm64_sequoia: "df5ae8370ee4eac8c0091a3b688b9558120fc20aff639b944b8d70e086119e32"
    sha256 cellar: :any, arm64_sonoma:  "d10beb4cc19528de0a7a8f4a326b5b306b3797caba391278d2424e7886b151b4"
    sha256 cellar: :any, sonoma:        "1d560b442e3c3154b8eaf994e288b6d22330c55e8ae486bd6cb7dbd0b483c59e"
    sha256 cellar: :any, arm64_linux:   "a14a34dde612f2e5f1307b427a24477d4844c79457fa9010baea57655751d5fa"
    sha256 cellar: :any, x86_64_linux:  "4e7cffbb994066abe8c97e83af790e11c88facc64c633231d1515b90b06e1e37"
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

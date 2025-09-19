class AwsLc < Formula
  desc "General-purpose cryptographic library"
  homepage "https://github.com/aws/aws-lc"
  url "https://github.com/aws/aws-lc/archive/refs/tags/v1.61.2.tar.gz"
  sha256 "c00ef64bd3c2bb50079069bfc1a6f3414cb88564416efe3cc83c63b815b74d55"
  license all_of: ["Apache-2.0", "ISC", "OpenSSL", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b6a19468062ea56778362d10b6bf57babd67fe7870651d2949f2125bbfb5c10"
    sha256 cellar: :any,                 arm64_sequoia: "547583e91daa71beeeba1b9fa8cd4197cb0b603843477ebc8a43ee911f4dcd14"
    sha256 cellar: :any,                 arm64_sonoma:  "7966c6ab0847407e3119952bbfdbff92cade67b8f147917490407bb3234eca9b"
    sha256 cellar: :any,                 sonoma:        "ed386a3eb1f889cd131450d709a55f9335ddd2f92e82a0976231df762d8afa0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7651ec5f3979391d1a4441973c1e402dd1c264b8f9cd09793ef0539f022b5db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb9213a83e13e0fe47d7eabfd16c5bd0535689563db6ad3b7a4a7c67d1b65a0"
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

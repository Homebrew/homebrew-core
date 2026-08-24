class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "1e432f0559a4ab512143b9bff7a700541a2c8d4712b26a72de3e0222790da305"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "71c4450282d28c9be6c633e172c182585243a2161ee308f58e6a4bbcc7c31f31"
    sha256 cellar: :any, arm64_sequoia: "33c3fe5af0603016a6c8fc1d00101e1787218f93977abc7d3487993b4980b623"
    sha256 cellar: :any, arm64_sonoma:  "8b731bb98e24c0fe2603cdc584b4eb3c685b275e5ee053987aac3d547a693398"
    sha256 cellar: :any, sonoma:        "9bb4fcd84c7984c457b8694f837cb3fb59f4748c77e1300f740de782c6b5be74"
    sha256 cellar: :any, arm64_linux:   "73cb935fdfbf13203435aa27915517382bc677986d7f2560a87916c102e1eba7"
    sha256 cellar: :any, x86_64_linux:  "ac49fff8ab388d233388bb4e5ddd0461eb8d9a662a479b763251bb2c6f0bbecd"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/pages\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end

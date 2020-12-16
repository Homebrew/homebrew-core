class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/0.4.0.tar.gz"
  sha256 "05836cd2b5c70197b3b6eed68b97d0ccb2c445061d5c19c15aef7c959842de0b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "37ccef44b4ea6d76bbd98343ef266dda8d3f6b7c103f981a4194ecd841685017" => :big_sur
    sha256 "ffd8b834836ed6b28606c173766f99d168c57b322153cbea5100bbbc27e1073d" => :catalina
    sha256 "1253594d96910c9bea3566d75461de4e497097dd24e94fcddb232dac3d2bdbfd" => :mojave
    sha256 "c0fb642f6934a0413fbd2e4a32a02f8cd5e7b7491f3f6d6423ab4856cef8f5df" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-GNinja", "-DBUILD_SHARED_LIBS=ON"
      system "ninja"
      system "ninja", "install"
    end
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/example_kem.c", "test.c"
    system ENV.cc, "-I#{include}", "-L#{lib}", "-loqs", "-o", "test", "test.c"
    assert_match "operations completed", shell_output("./test")
  end
end

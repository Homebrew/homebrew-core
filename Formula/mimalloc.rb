class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  # 2.x series is in beta and shouldn't be upgraded to until it's stable
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "b1912e354565a4b698410f7583c0f83934a6dbb3ade54ab7ddcb1569320936bd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DMI_INSTALL_TOPLEVEL=ON"
      system "make"
      system "make", "install"
    end
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end

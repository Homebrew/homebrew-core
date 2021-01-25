class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/v0.6.1.tar.gz"
  sha256 "336856bea0216fe0ddc6cc584be5823cfd3a142e9d90d8e1635d2d2a5241f584"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "ea135142e634f7a77cf868433f3ec31763994bef4464c93d51353457a06c7122" => :big_sur
    sha256 "4566b3b20c376b7bf318d93f7b17b34fc50498e236abb3e1a9b7fd53053862e8" => :arm64_big_sur
    sha256 "2ced17b347e593ca2de3533417ad5a898ac2e87c29e08a434657c236fd2111c2" => :catalina
    sha256 "a600e76cd093e6f06e9f1ae621efc31614c086f03df0087842c0f70fa583623a" => :mojave
    sha256 "5b49cd6443938d9d4423fa0b941c85da37f22f48a14c11c03c890588f14e40a3" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    pkgshare.install "examples/example.c"
  end

  test do
    fixture = test_fixtures("test.png")
    cp pkgshare/"example.c", testpath/"example.c"
    system ENV.cc, "example.c", "-L#{lib}", "-I#{include}", "-lspng", "-o", "example"

    output = shell_output("./example #{fixture}")
    assert_match "width: 8\nheight: 8\nbit depth: 1\ncolor type: 3 - indexed color\n" \
                 "compression method: 0\nfilter method: 0\ninterlace method: 0", output
  end
end

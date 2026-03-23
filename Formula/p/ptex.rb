class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "6b4b55f562a0f9492655fcb7686ecc335a2a4dacc1de9f9a057a32f3867a9d9e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "180dc89f0792317b8800689587ccbcb1b36e0d2316f8811467323361cd7152c4"
    sha256 cellar: :any,                 arm64_sequoia: "31009fa3315b845913d355b230e40a2cbc321fe3b250fd7c6149e78827d0cb09"
    sha256 cellar: :any,                 arm64_sonoma:  "25cfb86f4efe5aaa92239bf7b862d852ce5fef2a228bf81494b6b3ca10f674ae"
    sha256 cellar: :any,                 sonoma:        "95017074b589ede0043a7974a045faeb7e6a7945400e44bce17a400ccf811949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dbcf9a26c757d9404ae835e3e35903ca65adc10f76d23bc9fea920d3a608b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "893722f8de667f5d9fdbf20d04b89868e5d9d05484272f68f16dfd20afc50aee"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libdeflate"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-wtest" do
      url "https://raw.githubusercontent.com/wdas/ptex/v2.4.2/src/tests/wtest.cpp"
      sha256 "95c78f97421eac034401b579037b7ba4536a96f4b356f8f1bb1e87b9db752444"
    end

    testpath.install resource("homebrew-wtest")
    system ENV.cxx, "wtest.cpp", "-o", "wtest", "-I#{opt_include}", "-L#{opt_lib}", "-lPtex"
    system "./wtest"
    system bin/"ptxinfo", "-c", "test.ptx"
  end
end

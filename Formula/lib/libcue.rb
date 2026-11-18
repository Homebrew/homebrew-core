class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://github.com/lipnitsk/libcue/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "ca058ffab917f2ec66f442794f4cf0c75f51702bbeafbebaff8c682e3a8f82e9"
  license "GPL-2.0-only"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c6b3e2c2586518bb4a7119dbae1b4c774403f5582cd7a167fc7a04da2f235776"
    sha256 cellar: :any, arm64_tahoe:       "198d47a1351eefcf24e1834716f54ae87fd4fee9ccff6fbc7dee4a81c8bcfb06"
    sha256 cellar: :any, arm64_sequoia:     "d0e586de95e4f4a86d04f19371c4988fa3617037d29bf524bdbf6f51cfb8fcf5"
    sha256 cellar: :any, arm64_linux:       "f58452b8732d015bd065d3aeebb0b72046b6c6854a3db4c3b8765cc2f8e7e4d0"
    sha256 cellar: :any, x86_64_linux:      "769f2d4b8eb5420fbb01f0fb3cb09cb55f7fe77d804920e9a110cb9f103ce981"
  end

  depends_on "bison" => :build # Needs bison 2.4+
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"tests").install Dir["t/*"]
  end

  test do
    cp_r (pkgshare/"tests").children, testpath
    Dir["*.c"].each do |f|
      system ENV.cc, f, "-o", "test", "-L#{lib}", "-lcue", "-I#{include}"
      system "./test"
      rm "test"
    end
  end
end

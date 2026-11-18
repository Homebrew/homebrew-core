class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://github.com/lipnitsk/libcue/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "ca058ffab917f2ec66f442794f4cf0c75f51702bbeafbebaff8c682e3a8f82e9"
  license "GPL-2.0-only"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fef94041bf68f96aaa03a479dc4f8034638ca4ba01bc9c54c647ec1f758d407d"
    sha256 cellar: :any, arm64_tahoe:       "703c94d9986a00f797b808bf892629f1eeefee82c6d75e8a50614f80432bbea2"
    sha256 cellar: :any, arm64_sequoia:     "87020ed967b4a7accf127f12df7f81e4b553b1c8042acc9a1333d359d1be6f52"
    sha256 cellar: :any, arm64_linux:       "218f92594e3172d977a2981c23d64e17765900a476a872ea4bbf8ab91e962ab7"
    sha256 cellar: :any, x86_64_linux:      "22af14bd78c5c426db4977e8054233c985fc2985850c2f405f3b7ae953780af4"
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

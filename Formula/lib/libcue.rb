class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://github.com/lipnitsk/libcue/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "d972a35ef525c2d8aacc6d8dd47ac9379d9abf8166cdae93b2e385f287476918"
  license "GPL-2.0-only"
  compatibility_version 1

  bottle do
    manifest_sha256 "c2da556df94be2088c08237dab0a6ad317a3b68c45b2987aaf327b078d159001"
    sha256 cellar: :any, arm64_golden_gate: "34a0260e2abd44f4bbc2363a56f0a1788600fccd5b323019063a5df2140adee9"
    sha256 cellar: :any, arm64_tahoe:       "2387f929652ddb9563d9b50b6f64d63edbc2557fa361dab357d2872ca89cb9c0"
    sha256 cellar: :any, arm64_sequoia:     "9b1e9717ce696c4371e3990d44cba85d39b247bf2d4899283fe6f8a0c12aa6aa"
    sha256 cellar: :any, arm64_linux:       "843d287df589b434a40d196972be6225b1a7ea74785077b321ed512674f6b7d4"
    sha256 cellar: :any, x86_64_linux:      "edaf4b16bc74651435c139bff9b3afdf64013e591091ccfa19fbb8882e31b808"
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

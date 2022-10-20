class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "a9b8a1509cbd5f4de27a0709fb61091e9118ee86ed76a69d983007bf62b13ccd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9271ade6dff08d3f7822bdeee5dd79391c4b60a7a4bd031fb475089f2b946bf3"
    sha256 cellar: :any,                 arm64_big_sur:  "bab832b74b45234b6681b4a7e7309a00a0fc52e999c333bbf5ca98f67be183fa"
    sha256 cellar: :any,                 monterey:       "3a7bc5999b918155a18524dbaf14b5c6440b6af5af6eb0594b08929b9bcaec8e"
    sha256 cellar: :any,                 big_sur:        "702e952a6cc56846fa427b7b9ffd85dd22d78d36e7c31ffa3922dc32b0ca9354"
    sha256 cellar: :any,                 catalina:       "a833e7ae16c9e43be139876938c68ffeac01bd6b14dc67470f346ce398694fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd7a16e2b34bbbec8fd8b7f021d23126d5f486e8cfd5621cde33d66fa5271273"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end

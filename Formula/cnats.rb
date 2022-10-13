class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "a9b8a1509cbd5f4de27a0709fb61091e9118ee86ed76a69d983007bf62b13ccd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f683a574015b6e87b1c4bfe49c00aaa0e229df56946103e78cf104f6ebcf73d"
    sha256 cellar: :any,                 arm64_big_sur:  "6f9fddecf458690aefaa965c21e64236c925c47fce554be2a5c88666f8222119"
    sha256 cellar: :any,                 monterey:       "e1a9a1c8604c041cd63d01f1dfaa3c11fe1b907877c7b30b1b902473b1246e7a"
    sha256 cellar: :any,                 big_sur:        "7472d97a32fac04e4e9339a80542b1ffcb722a322849d9e72e82aeb185bb0169"
    sha256 cellar: :any,                 catalina:       "ec438865afd882af4b51f3c2157f7d349439edf3e212ff69da7e08c311bb45f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bb001771e77ac2d44092ea53c76266da26daa5ec5e00f8060a9ea3c4725cfa1"
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

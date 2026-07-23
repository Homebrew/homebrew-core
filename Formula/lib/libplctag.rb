class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "0d38e9313c312010f2f84a3aa14b155d8bd16fe923b42ae72a8f81f231cd4c78"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "59707115e62dc20b5b5c7e9ed398140f46439304a4fed549337b6e0acfad734a"
    sha256 cellar: :any, arm64_sequoia: "fde4499769c2636a96763d4c0216154de3fb023348147710c591dd9b088de2ea"
    sha256 cellar: :any, arm64_sonoma:  "fc9445b096d9979793ec8ae29e4caa21bc3ff8c904cfe23641d20c9eac96410f"
    sha256 cellar: :any, sonoma:        "ceb43c6648bb85990a89d01effc37c2a93d5e9ec40769dec4df3eff205d34c7a"
    sha256 cellar: :any, arm64_linux:   "ea9d3483a3c761cbdb3a40c32c9a03c113152e97e8f8a2ec647b50ea5d874e51"
    sha256 cellar: :any, x86_64_linux:  "fb02dbe49fd69a9adf4e73693287299d642a6684ab1f0f7c86d279ed2afa3e91"
  end

  depends_on "cmake" => :build

  # Backport "ab_server: scope CIP_SRV_UNCONNECTED_SEND case body"
  patch do
    url "https://github.com/libplctag/libplctag/commit/b19081bc35bd93893b343091add7d638ee3fe532.patch?full_index=1"
    sha256 "7b84abb42b4ba7b72b2b391f471acc56719481b590634cd1afd0576e7d1e1432"
    type :backport
    resolves "https://github.com/libplctag/libplctag/pull/618"
  end

  def install
    # Vendored libyafl uses MAP_ANONYMOUS which requires _GNU_SOURCE on Linux
    ENV.append "CFLAGS", "-D_GNU_SOURCE" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end

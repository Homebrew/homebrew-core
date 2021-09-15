class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.2.1.tar.gz"
  sha256 "c5ee6a5591c644b97f83ecff339abfa8e01e06fa4af126df4b226a425df5f056"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 arm64_big_sur: "8a2632dded34cf0fb3276450aa1c50da27b72e9f29b0ab1e669f68665e5948dc"
    sha256 big_sur:       "78e1ae2880a9faf26cb1547f4f97c7c2e5b2793c17bd8857c2f7457d05006ac4"
    sha256 catalina:      "91b6eb7779b6053e086246f41076d38b141f2f6c0b1dfa133ed18486039a92be"
    sha256 mojave:        "878a0815e2be09e485decf50128ee6ed4adc84996ff1ab36102e1faa4f581d8a"
    sha256 x86_64_linux:  "176c9b7a0d141c6476f95bd2a3fccb1fbdbc35a1b96aef3757c9511a843fa4b3"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DLCB_NO_TESTS=1",
                            "-DLCB_BUILD_LIBEVENT=ON",
                            "-DLCB_BUILD_LIBEV=ON",
                            "-DLCB_BUILD_LIBUV=ON"
      system "make", "install"
    end
  end

  test do
    assert_match "LCB_ERR_CONNECTION_REFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end

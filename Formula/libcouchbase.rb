class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.2.4.tar.gz"
  sha256 "ac5774695906d5482ea5d92cc9e47826eb979c6a784114a259bd748aa4774c3a"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 arm64_monterey: "5a779c707052e820cd2faed4e8e4b6f96ceede06f57277161c3b6b38561c32f9"
    sha256 arm64_big_sur:  "1aa9f0839809a8b8701142f946fa45a36fe2cf7bf5042195284f46669bae8bfb"
    sha256 monterey:       "fee52a8f33c3868df4bc9336b2b1664e32a798ee2b5dda441bd1ea8f1e751399"
    sha256 big_sur:        "2c54f96a26c5db5b9dde6d0636d62f18abfcea5b06d612de4c961ffdabb0a2ac"
    sha256 catalina:       "05a73fbee2eb8adc53d5edf9fbda2b18ca39c993cb89d8a75be6ab95b53da5bf"
    sha256 x86_64_linux:   "30a92f67630091008ab654c636707f63ebeb9879a79e9d04800e047aa7143e56"
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

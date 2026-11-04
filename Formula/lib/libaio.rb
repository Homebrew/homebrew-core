class Libaio < Formula
  desc "Linux-native asynchronous I/O access library"
  homepage "https://codeberg.org/jmoyer/libaio"
  url "https://codeberg.org/jmoyer/libaio/releases/download/libaio-0.3.113/libaio-0.3.113.tar.gz"
  sha256 "2c44d1c5fd0d43752287c9ae1eb9c023f04ef848ea8d4aafa46e9aedb678200b"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://codeberg.org/jmoyer/libaio.git", branch: "master"

  # This regex only captures the first three numeric parts of the version
  # (e.g., 0.3.110) and omits the optional trailing number (e.g., 0.3.110-1 or
  # 0-3-107.1).
  livecheck do
    url :head
    regex(/^libaio[._-]v?(\d+(?:[.-]\d+){1,2})(?:[.-]\d+)*$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_linux:  "71422db16966460328f8c89a349abcaecc642dc4c2b8643e04cc9a48a50de956"
    sha256 cellar: :any, x86_64_linux: "4f4c61ab5f3face78661d57d5e988d47a37a4e7e1d7830889f0f50b511030651"
  end

  depends_on :linux

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libaio.h>

      int main(int argc, char *argv[])
      {
        struct io_event *event;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laio", "-o", "test"
    system "./test"
  end
end

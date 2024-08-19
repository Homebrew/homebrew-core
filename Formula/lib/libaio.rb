class Libaio < Formula
  desc "Linux-native asynchronous I/O access library"
  homepage "https://pagure.io/libaio"
  url "https://pagure.io/libaio/archive/libaio-0.3.113/libaio-libaio-0.3.113.tar.gz"
  sha256 "716c7059703247344eb066b54ecbc3ca2134f0103307192e6c2b7dab5f9528ab"
  license "LGPL-2.1-or-later"
  head "https://pagure.io/libaio.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, x86_64_linux: "780180556365b75239ec9086fb73b2f77bd5c9350e9ed6d0fbd222ce758c6dcc"
  end

  depends_on :linux

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libaio.h>

      int main(int argc, char *argv[])
      {
        struct io_event *event;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laio", "-o", "test"
    system "./test"
  end
end

class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://hobbes1069.fedorapeople.org/freetel/codec2/codec2-0.8.tar.xz"
  sha256 "361e0aa7e9634f64cef17239d03a2564fe117f2743463ec915f1272901f6025f"

  bottle do
    cellar :any
    sha256 "205941857ee7183277550016a6f6bd01c95be627e5c3594adc1674bd1bf2e03e" => :high_sierra
    sha256 "516e46003f5a9921ef6ea76ce1321de5de54790ece96a84b9d78d578e4565544" => :sierra
    sha256 "4db77776f89f5888824a0984a28c37ec9d568ef6f1e4c34cab5fe8b131db7fd0" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build_osx" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # 8 bytes of raw audio data (silence).
    (testpath/"test.raw").write([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack("C*"))
    system "#{bin}/c2enc", "2400", "test.raw", "test.c2"
  end
end

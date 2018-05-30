class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://hobbes1069.fedorapeople.org/freetel/codec2/codec2-0.8.tar.xz"
  sha256 "361e0aa7e9634f64cef17239d03a2564fe117f2743463ec915f1272901f6025f"

  bottle do
    cellar :any
    sha256 "539032d65d38749f4dde5970d653761a3de4ce6d9007a4cc0f535847686596c7" => :high_sierra
    sha256 "ecba1a173dbda214953179e8c7200637934b905ec3b2ec3dc9fd8785a20bdb1c" => :sierra
    sha256 "6aeab3c08a575914a615f0051b73464ffe19a4bde2c7595d93db5698ff054fa0" => :el_capitan
    sha256 "78ccb93fb8936706594ef14d7b37762498ea52c7f00b2c91804608172b890dc8" => :yosemite
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

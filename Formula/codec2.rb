class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/v0.9.2.tar.gz"
  sha256 "19181a446f4df3e6d616b50cabdac4485abb9cd3242cf312a0785f892ed4c76c"

  bottle do
    cellar :any
    sha256 "3316417a3e0244dcdc81466af56be6d323169f38c3146075e9314da92c60c938" => :catalina
    sha256 "92031b75a027390385864b1c2a4bde522da712162b7c6f8187a1b2adf74f8504" => :mojave
    sha256 "37a6ae2407ae97ae632078020e89163e9b58d3613207bcf534401f6660128108" => :high_sierra
    sha256 "d90f5373ac39385b8fffee0605afe2e27c195f44ef211f98d7b5d89c7200508d" => :sierra
    sha256 "896b96db4b2d4349ca56dc0e4daaf2bebfc28908197c013aefe89d86fe57317c" => :el_capitan
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

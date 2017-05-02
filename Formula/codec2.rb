class Codec2 < Formula
  desc "Open source speech codec."
  homepage "http://www.rowetel.com/blog/?page_id=452"
  url "https://files.freedv.org/codec2/codec2-0.6.tar.xz"
  sha256 "57754bf3507a7ac9f9402cae054787a3572bea6a791137cdd5fa35f6c5af1144"

  bottle do
    cellar :any
    sha256 "585a3616ef9fded0a072c3b481868e893134e8a8418b927aa2afc66400a17a89" => :sierra
    sha256 "4b0b0e851ced2d176332a0a5c2f6e6daa09d9d7c18926fa091ac976222ee2872" => :el_capitan
    sha256 "f8d6620efa72f62a4e34891266880547e3db64f3b05c5457348cc1ff071148d0" => :yosemite
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

class Libcaption < Formula
  desc "Library for the creation and parsing of closed caption data"
  homepage "https://github.com/szatmary/libcaption"

  url "https://github.com/szatmary/libcaption/archive/0.7.tar.gz"
  # version "0.7"
  sha256 "125c9c55e1d5f0dc37ef151fa9583dd2fcfaefe7699d348c7292e634859e527e"

  depends_on "cmake" => :build
  depends_on "ffmpeg" => [:build, :test]
  depends_on "re2c" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Create an FLV video file
    INPUT_VIDEO = testpath/"input_video.flv"
    system "ffmpeg", "-report", "-hide_banner",
    "-f", "lavfi", "-i", "smptebars=duration=2:size=640x360:rate=30",
    "-c:v", "libx264", "-crf", "23", "-preset", "ultrafast",
    "-f", "flv", INPUT_VIDEO

    INPUT_CAPTION_FILE = testpath/"input_caption.srt"
    INPUT_CAPTION_FILE.write <<~EOS
      1
      00:00:00,000 --> 00:00:02,000
      Caption Text
    EOS
    OUTPUT_FILE = testpath/"output.flv"
    system bin/"flv+srt", INPUT_VIDEO, INPUT_CAPTION_FILE, OUTPUT_FILE
    assert_predicate OUTPUT_FILE, :exist?
  end
end

class DoviConvert < Formula
  include Language::Python::Shebang

  desc "Dolby Vision Profile 7 to 8.1 MKV converter"
  homepage "https://github.com/cryptochrome/dovi_convert"
  url "https://github.com/cryptochrome/dovi_convert/archive/refs/tags/v7.3.2.tar.gz"
  sha256 "8252401d8506a12de011de1762d9546f8437e77cf1de155e23eb39523b826634"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58290fcc0779e2adcede1b5fe0fe33e5e4b7e3f198176062d4dd1d57a08a874e"
  end

  depends_on "dovi_tool"
  depends_on "ffmpeg"
  depends_on "media-info"
  depends_on "mkvtoolnix"
  depends_on "python@3.14"

  def install
    rewrite_shebang detected_python_shebang, "dovi_convert.py"
    bin.install "dovi_convert.py" => "dovi_convert"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dovi_convert 2>&1")
    cp test_fixtures("test.mp4"), testpath/"test.mp4"
    system "ffmpeg", "-i", testpath/"test.mp4", "-c", "copy", testpath/"test.mkv"
    output = shell_output("#{bin}/dovi_convert -convert #{testpath}/test.mkv 2>&1", 1)
    assert_match "Error: Input file is not a Dolby Vision Profile 7 file", output
  end
end

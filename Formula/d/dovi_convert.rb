class DoviConvert < Formula
  include Language::Python::Shebang

  desc "Dolby Vision Profile 7 to 8.1 MKV converter"
  homepage "https://github.com/cryptochrome/dovi_convert"
  url "https://github.com/cryptochrome/dovi_convert/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "bf6d9a634d66415b96faa4ee90c0e60149b91b5ab0c53dfb4111cdb2f593ed40"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd0e7cd8a783a1aa0fd13df1c0c0b4728f6ec6f49f24705088bed20baa44dab0"
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
    output = shell_output("#{bin}/dovi_convert convert #{testpath}/test.mkv 2>&1", 1)
    assert_match "Error: Input file is not a Dolby Vision Profile 7 file", output
  end
end

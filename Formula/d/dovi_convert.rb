class DoviConvert < Formula
  include Language::Python::Shebang

  desc "Dolby Vision Profile 7 to 8.1 MKV converter"
  homepage "https://github.com/cryptochrome/dovi_convert"
  url "https://github.com/cryptochrome/dovi_convert/archive/refs/tags/v7.3.1.tar.gz"
  sha256 "ab53d2a64524ebb26ff3734c199d93d948848d00ea1fe7565abf132f5bd3f7e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8478fae5ae341ee2c41709819529d0473a39829d47e5a5d1deed0999b070d148"
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

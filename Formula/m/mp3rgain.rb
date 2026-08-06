class Mp3rgain < Formula
  desc "Lossless MP3/M4A/FLAC/OGG volume adjustment (modern mp3gain replacement)"
  homepage "https://github.com/M-Igashi/mp3rgain"
  url "https://github.com/M-Igashi/mp3rgain/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "f2507338804ac2d5c7e7728a33222b38e0c59dfdeaf907e19487a9d436602ecc"
  license "MIT"
  head "https://github.com/M-Igashi/mp3rgain.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    cp test_fixtures("test.mp3"), testpath/"test.mp3"
    system bin/"mp3rgain", "-g", "1", testpath/"test.mp3"
    assert_match "MP3GAIN_UNDO", shell_output("#{bin}/mp3rgain -s c #{testpath}/test.mp3")
    assert_match version.to_s, shell_output("#{bin}/mp3rgain --version")
  end
end

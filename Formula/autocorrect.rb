class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.4.0.tar.gz"
  sha256 "4b63bf9d28bbac00bda4f63366fb3031979fa666607811cf22363dc73db70c80"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce89c50d04953517d799fc441cc8d4750154116cf01c72c0ee6ea9875e8712bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96d595138e7a575ab0a843c145fad3855bdcd080b2229fd698f6c1438be16a33"
    sha256 cellar: :any_skip_relocation, monterey:       "1ae8a57a3eb2c16ae8709e28b14cf1d86e6c58e5358a34fee9440b0d29e87c14"
    sha256 cellar: :any_skip_relocation, big_sur:        "5232a223ecef46139426acd00bf058a573dce847e8384018f62d396730dcc123"
    sha256 cellar: :any_skip_relocation, catalina:       "127a7ec32eb840353a0cdbce23e6a0cff9e0c7170b9e4dc976aed84fd04d5e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc94b148a56eec91030ece45af68b4c73525a00af727affd0209ebcc9418c35"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end

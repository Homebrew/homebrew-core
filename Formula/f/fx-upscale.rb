class FxUpscale < Formula
  desc "Metal-powered video upscaling"
  homepage "https://github.com/finnvoor/fx-upscale"
  url "https://github.com/finnvoor/fx-upscale/archive/refs/tags/1.2.6.tar.gz"
  sha256 "ced81b777a5b0892754f1be1c2c6772ffab3b7becd867f312300f1a296b66375"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0f620bda60b7d000408b66c42e1e96605035df1405052d68256cdcb56ef5406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c97e26e89b16e1b5757f59f6a663d49a7e02d4abcb50cc1bf2720bd6ea2a995"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ec14d59739a1c80918ae3021a350cecec106c22858ec1b9cd3138d4a0efcdd"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/fx-upscale"
  end

  test do
    cp test_fixtures("test.mp4"), testpath
    system bin/"fx-upscale", "-c", "h264", testpath/"test.mp4"
    assert_path_exists "#{testpath}/test Upscaled.mp4"
  end
end

class Nef < Formula
  desc "💊 steroids for Xcode Playgrounds"
  homepage "https://nef.bow-swift.io"
  url "https://github.com/bow-swift/nef/archive/0.6.2.tar.gz"
  sha256 "23915dd21e6485829b5ad88b6a5f4ac6b4ea091fc70820d2322bafba09e2217a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621c034f7b2d64932fa58d3fe47f1c20a082adb4d1574a2bd6e79ca79d61600b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5b6f8469fa1102d9e6493f179a51506aacd9aa4c475717a7f4bdeb8faffea0f"
    sha256 cellar: :any_skip_relocation, monterey:       "dd772e8001aaa5a9a2543e3952a57350207b10879765ef5893e36aebc55a6a1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "11c4a5eb869ab0e94f430c3ff4104064e0ec3b371ed4e0d6c8673ac9f18915ee"
    sha256 cellar: :any_skip_relocation, catalina:       "fae01b5b21abe8205e3e42101804f3c6c16bb04d1c14841846766579ce2885d5"
  end

  depends_on xcode: "11.4"

  def install
    system "make", "install", "prefix=#{prefix}", "version=#{version}"
  end

  test do
    system "#{bin}/nef", "markdown",
           "--project", "#{share}/tests/Documentation.app",
           "--output", "#{testpath}/nef"
    assert_path_exists "#{testpath}/nef/library/apis.md"
  end
end

class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.3.0/easyengine.phar"
  sha256 "424cf6a7ebaa96b089f059cfd28563973170002df2c78cb93a893cb1c7732cfe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3d796a515401acd769c914812c7d0be6fb4b1f535de6e705580414a5cf87cc4"
    sha256 cellar: :any_skip_relocation, big_sur:       "718e08b3f0a87e69b321c97844c8840a4017b484df1686bf2dc4a99c1a230e66"
    sha256 cellar: :any_skip_relocation, catalina:      "718e08b3f0a87e69b321c97844c8840a4017b484df1686bf2dc4a99c1a230e66"
    sha256 cellar: :any_skip_relocation, mojave:        "718e08b3f0a87e69b321c97844c8840a4017b484df1686bf2dc4a99c1a230e66"
  end

  depends_on "dnsmasq"
  depends_on "php"

  def install
    bin.install "easyengine.phar" => "ee"
  end

  test do
    system bin/"ee config set locale hi_IN"
    output = shell_output("#{bin}/ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}/ee cli info")
    assert_match "Darwin", output
  end
end

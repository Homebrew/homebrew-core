class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "08",
      revision: "49e4029728927afb1a22864698be10cf445413aa"
  head "https://repo.or.cz/neatvi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a49881c62f05798cf8016e0e6dfb3e00a368c86d338e9ddb332f3f0917e12706"
    sha256 cellar: :any_skip_relocation, big_sur:       "369536734eff4dea2a061a45b61060b9b91400599c2b5149cc56ec889b0c14a5"
    sha256 cellar: :any_skip_relocation, catalina:      "c2c83bfb47a438d99fb7086a756292a4442dfb1d7eebd0314132814201cd944e"
    sha256 cellar: :any_skip_relocation, mojave:        "240fb8ec097a95ed3bb86f02f6f3fbd074b671529055009835eb95c6f2dccc6d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4244c126297140059a43449c435407de2d041486bc56ea44bd2d324649304818"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end

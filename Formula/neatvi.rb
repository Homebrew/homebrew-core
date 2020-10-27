class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "08",
      revision: "49e4029728927afb1a22864698be10cf445413aa"
  head "https://repo.or.cz/neatvi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2c83bfb47a438d99fb7086a756292a4442dfb1d7eebd0314132814201cd944e" => :catalina
    sha256 "240fb8ec097a95ed3bb86f02f6f3fbd074b671529055009835eb95c6f2dccc6d" => :mojave
    sha256 "4244c126297140059a43449c435407de2d041486bc56ea44bd2d324649304818" => :high_sierra
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end

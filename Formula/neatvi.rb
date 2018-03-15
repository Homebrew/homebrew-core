class Neatvi < Formula
  desc "ex/vi clone for editing bidirectional uft-8 text"
  homepage "http://repo.or.cz/w/neatvi.git"
  url "http://repo.or.cz/neatvi.git",
    :tag => "06", :revision => "5ed4bbc7f12686bb480ab8b2b05c94e12b1c71d8"

  head "http://repo.or.cz/neatvi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e34d03e212479064e86e8d1024447badeb61a54205f1fda24f9b6633e22afe7" => :high_sierra
    sha256 "339a7880dea5f7ff0e290bc890f95719da7e5ba4b64a7205760c8f6cf64e10a2" => :sierra
    sha256 "c773025ad559bb25cc095a7e1efc8950424a4cd86ff81ee4b0093a0e2e3c3c84" => :el_capitan
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end

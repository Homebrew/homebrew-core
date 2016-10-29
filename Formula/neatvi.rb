class Neatvi < Formula
  desc "ex/vi clone for editing bidirectional uft-8 text"
  homepage "http://repo.or.cz/w/neatvi.git"
  url "git://repo.or.cz/neatvi.git",
    :tag => "04", :revision => "3bf27b04ec791df5a624dc4487422f382b96327c"

  head "git://repo.or.cz/neatvi.git"

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end

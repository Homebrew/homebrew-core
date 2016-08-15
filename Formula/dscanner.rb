class Dscanner < Formula
  desc "The Dscanner untility for the D programming language"
  homepage "https://github.com/Hackerpilot/Dscanner"
  url "https://github.com/Hackerpilot/Dscanner/archive/v0.3.0.tar.gz"
  sha256 "2b5578ca98ad6805a1f1494dfbf90c8f491da20bfe5103ca0c8ac73d781558fe"
  depends_on "dmd" => :build
  depends_on "dub" => :build

  def install
    system "dub", "build"
    bin.install "dscanner"
  end

  test do
    system "#{bin}/dscanner" "--version"
  end
end

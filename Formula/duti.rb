class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/russellhancox/duti"
  url "https://github.com/russellhancox/duti/archive/master.tar.gz"
  version "1.7"
  sha256 "fbfaf180b3f24690e60a406d2dbca90b86e907f719a8ef4e9d38965fc0a44cea"
  head "https://github.com/russellhancox/duti.git"

  def install
    bin.mkpath
    system "make"
    bin.install "duti"
    man1.install "duti.1"
  end

  test do
    system "#{bin}/duti", "-x", "txt"
  end
  
end

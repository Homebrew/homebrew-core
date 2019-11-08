class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.6.tar.gz"
  sha256 "e5e505ff7c7363fed6dbeed7ccefb3af726312ae19fd290b3179f5d41cb63d22"

  bottle do
    cellar :any_skip_relocation
    sha256 "06ff55a2834ad01a262b66f181a8c99800157ec0f465f80e0cc3518be7ebd1da" => :catalina
    sha256 "e5176c32457d725bf14ccb0d36e570996db4571428cc21a8f562bf938c86e17e" => :mojave
    sha256 "d532d4c449e12039bbe0d4f539f96b8a0b7d77c5bc2615c620b627ffafa265bf" => :high_sierra
    sha256 "baa97a5223e66e67786dbd786df0c75467393fdff9df0594e57a084097d9e7b6" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/iawia002/annie").install buildpath.children
    cd "src/github.com/iawia002/annie" do
      system "go", "build", "-o", bin/"annie"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end

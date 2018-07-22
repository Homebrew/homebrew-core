class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.9.tar.gz"
  sha256 "eaa0d0a8c195517bb94684e55aafa343cf182afe0bc61a5b5e4cad7cf8d33241"

  bottle do
    cellar :any_skip_relocation
    sha256 "49575a6536cb9ea54d6ac9f0ea7a55715c6908a2fff2e49a3bce479c17d16f53" => :high_sierra
    sha256 "c1c429d64d1c27083f5501342c718fe2bb43925f4483df43d4fc26599d4a3e11" => :sierra
    sha256 "07dcb8b6ee30fd5c174490421d5495198a14971fad581af7eec2c59280952a6c" => :el_capitan
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

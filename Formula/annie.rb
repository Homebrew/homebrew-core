class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.4.tar.gz"
  sha256 "0b2125a21e7ffa51ebae5c4c6e1b28e0d20a5aeba588ad3d0ab6875c72c348a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b7b85fa047a19bdf54e893f59aeec7f611628de410e3404413697468b07fc29" => :high_sierra
    sha256 "76e63d6547939dd30138e0687d417f1b6fd018204274e3776aceebd0d3db81a9" => :sierra
    sha256 "e6c059373bc88c39a1a14f07b6f3d25e02519d93d83415c7b9c68efcea8323c7" => :el_capitan
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

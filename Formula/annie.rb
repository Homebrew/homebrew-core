class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.1.tar.gz"
  sha256 "135485d9cbf3711bfbea6b79090e898bef82ef329c922ed222e96c326b15af52"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b972d5cddcbd8b73facffb64350e191098b40501a72d837e05c975cbc49b832" => :high_sierra
    sha256 "14e1e304e3bcbe5a0d1206507396564500272b4841689143c9c49ec026481cc7" => :sierra
    sha256 "ba846f6771784ef25f9f4b286742bb322bcd56c4e1e1fb13a2780a67b67ff17e" => :el_capitan
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

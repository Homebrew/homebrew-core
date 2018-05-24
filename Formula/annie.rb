class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.1.tar.gz"
  sha256 "135485d9cbf3711bfbea6b79090e898bef82ef329c922ed222e96c326b15af52"

  bottle do
    cellar :any_skip_relocation
    sha256 "139cb39e47043c211a3b40eac839a8eccac66b8b78e0742ee9e5e6b678ee3944" => :high_sierra
    sha256 "5ea608b0254babd2968007366cde68f3c4e27970e6c994832e61fe4a15ee82e3" => :sierra
    sha256 "24f05f01a27055af95e6af7168dd52ac1ec196f177060bd3ff339a39ea60f0e2" => :el_capitan
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

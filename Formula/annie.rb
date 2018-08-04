class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.13.tar.gz"
  sha256 "2b0e69e05819f3084d20512904804ef821eda741971711971df6ef7f510f3dd2"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1949780dc3c5db00796f8b3a738f84a4c6555f0d4b9be1b97a4f56529be6447" => :high_sierra
    sha256 "d426de9a66c1c981cb0f12653aa43867089d861ba647553e877429f08454310d" => :sierra
    sha256 "254d69ee6c17b2179491e5a829c407cb86f98fbb06bc4605391f47392768d7e4" => :el_capitan
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

class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.5.tar.gz"
  sha256 "bf74a5e626ec0319fea990fc5665a2710232c069b8fcbc5ea136433076eade57"

  bottle do
    cellar :any_skip_relocation
    sha256 "e91528437934fb365d25c7e51922a508689db56e7326acfe90aab9584b274f61" => :high_sierra
    sha256 "f0900d5b86093cfb56e1a3739eecf636b83a6b7292fc57c2584bfd40c88e7c07" => :sierra
    sha256 "006e667a25e0210cafc9e2530fec196567b338e570901f1e9720740eb61ad5f1" => :el_capitan
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

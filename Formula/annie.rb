class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.12.tar.gz"
  sha256 "285645cacc392e05d750d817f4989ec233e21e11716412b478862a2ba8a00a83"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e022559b83811cdd7833ddd62e1a4ceeae0b1b9c2ac89c1ea09c9fd9233b1d7" => :high_sierra
    sha256 "290d760911da2fb6e5884bf6a385b633e05c8d33d4cd479b67ff4b6d11d15493" => :sierra
    sha256 "d6cf5fbf7f3f693156cdc9584c42ae8d64770227df9e0e8200e18f46f017b33f" => :el_capitan
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

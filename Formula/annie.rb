class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.6.12.tar.gz"
  sha256 "a713b2887381a07e49f5a705d001886fbe1e602ebba257ac569e03bb4bd84ba2"

  bottle do
    cellar :any_skip_relocation
    sha256 "1113b83891a1c0d69323432e75b9a883fc25b6881570058e1d1ddce3a69961fd" => :high_sierra
    sha256 "c704f7d0ccb86a2150fb031c2cb81dcf7f7e5fca86665f2dd56f3de6e2f48bb0" => :sierra
    sha256 "eae710859f006fc48671205f2b71f9a8e7657c06bf20eab2076115a359ce793f" => :el_capitan
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

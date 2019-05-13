class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.2.0.tar.gz"
  sha256 "1848a70457f6e634579619328f1792d68b97a0e2c10118b72b0cacf7e808360c"

  bottle do
    cellar :any_skip_relocation
    sha256 "e040a27d0aa0a46161e6c297ab58d4119148621983d4805b404882716e7fd9b7" => :mojave
    sha256 "89e047ad1f9180cf30eeaa89450ae6e12adfa164ca20411dffd1d45fa6ee838c" => :high_sierra
    sha256 "16026d3e2e70422c5725e0e4584400a1429fa5a8fe6f5fa275dd6e9518532e2f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/miguelmota/cointop"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "-test"
  end
end

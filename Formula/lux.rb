class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.14.0.tar.gz"
  sha256 "3d485c9703851f3fb5cdee9b029b5b6855f84bfd29b44cae310a031a6fa8c00f"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f580049bd8033547af807289952deccb1435752511e0cff46562a2e0ee0f710f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ec0c44a43b989408ca3bf89b1372dcc510080a4485dfbde8e6fe171184711ce"
    sha256 cellar: :any_skip_relocation, monterey:       "3ca33d92a5aebb2374c5f4905591cc5ac1205d8186eb5d23e7c61b8a85ddd681"
    sha256 cellar: :any_skip_relocation, big_sur:        "383a81d4b43aa2a2591c4bfe791ed29dcab48682ec012f7e09eb252cf3e92ab7"
    sha256 cellar: :any_skip_relocation, catalina:       "04df6baff952484442ba52c9e5f658ad588e5ff0b3d76818f8ad5cc46ad0b0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9731bb27deb30763d11090536359db7cb40d42fbfcc7d589f1b1ad6450ce59e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://www.bilibili.com/video/av20203945"
  end
end

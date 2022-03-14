class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.14.0.tar.gz"
  sha256 "3d485c9703851f3fb5cdee9b029b5b6855f84bfd29b44cae310a031a6fa8c00f"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0589ac7c3a3b4f7f1c74eb065f22e036d32b1af4661a5fbbf91923826817c72d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9323a16c565d6af2474bc03f741a586f172bc59f7459a3e0163715e70e1ab4a5"
    sha256 cellar: :any_skip_relocation, monterey:       "b23f6bee6925dace5fdb5b15ab4415447104e06e81329b03e1002f605db09f95"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2eb3207d3cfd3efd7e8f845b5929cd76e467a627b9c444e4279c09feb2c7d98"
    sha256 cellar: :any_skip_relocation, catalina:       "e08ea0a5bf404bebd44fe9a473886246dcc44e05436bb834f60da711ebecd3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a574c93fbd111451ced432e9a8abe5bb4e68f4c05ab910575cd6199fc9ba989b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://www.bilibili.com/video/av20203945"
  end
end

class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.32.1.tar.gz"
  sha256 "dc7df9a9e253e1124748aa74da94bf2b96f5a61d581c60d52d3f8e8dc86ecfde"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "567a8c1ca45ffae17d4901b0aa729be8866b6cb93ee8224da98cacf36f73ed69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b21230f43123e6b1a832f87d30f040d9f4684bb19f62f69f651bb24ae1cfaaab"
    sha256 cellar: :any_skip_relocation, monterey:       "68f7b9093d44fdef4210ffeaa8f88e8fa27bef356b4c8b2d4fc7749aab1d2614"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5dc03f040b2638a14e30c9fdeaaed616084539c0360fc916b53c3c8206259c4"
    sha256 cellar: :any_skip_relocation, catalina:       "2edc8e221d28db3da039490d4728d3c5ac7ce38d5274418b4d5f0ca31dfc0b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0356bf7cc43d0a1eb7777e7ed390f47f9dd8fb51cc480c8fb87fcde5fba1b4a"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end

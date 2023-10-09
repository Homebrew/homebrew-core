class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "a2bdcaadf7430aa6ce3e38e5c223e6b8178362cd7da0408f61d288bbed05bfe3"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92a4759be831ef7162b2972a22d8a3d46e4c9f2d7a4327759069aea3b1fc5893"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a257c9c164686b6529846e16f4a2a2b17189703fac6ddb71416cdb8626a714e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35b0067bd362b194fdda69e109fae00638dd68eec147eb864f77403da94b400f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3cc764542e6dd3ced7a216ac743645d5748c090a9f8e0dede01e0803bb64088"
    sha256 cellar: :any_skip_relocation, ventura:        "4ab2fb598abe970ebdb3f3bc2390fc6a598a84da23702eb466e1a15d9689958c"
    sha256 cellar: :any_skip_relocation, monterey:       "7aa78a19c5e005423e1b03fe96d805f907bdebcb57cbe071da4107b549688cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db5b1deb606022cd22d511b7524d847fd861e700cc7c82d4010ac2bf1b0e5d1c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end

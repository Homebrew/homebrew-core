class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.18.0.tar.gz"
  sha256 "e25f2f8f446948902129f23b75a66309628c51aace1589757bc9a3cf42734c8d"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07cc51480ec722a575ffaaa831cf054211e476c1dac509b0415a74ddec967daa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07cc51480ec722a575ffaaa831cf054211e476c1dac509b0415a74ddec967daa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07cc51480ec722a575ffaaa831cf054211e476c1dac509b0415a74ddec967daa"
    sha256 cellar: :any_skip_relocation, ventura:        "c4fd3bd655312a0bda95ba328428f4fa7e598661e8e3419f49d6950a453cde9e"
    sha256 cellar: :any_skip_relocation, monterey:       "c4fd3bd655312a0bda95ba328428f4fa7e598661e8e3419f49d6950a453cde9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4fd3bd655312a0bda95ba328428f4fa7e598661e8e3419f49d6950a453cde9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3da2b4ad17a35033354f5977b9ac6629d2865fe75e6f96c029b6289bea56f3e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end

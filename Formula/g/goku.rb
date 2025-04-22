class Goku < Formula
  desc "HTTP load testing tool"
  homepage "https://github.com/jcaromiq/goku"
  url "https://github.com/jcaromiq/goku/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "d03020d63d36465bda0f07b3f3790b9e33579afe176a25fd01e89e9e9d066fc1"
  license "MIT"
  head "https://github.com/jcaromiq/goku.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100754f13107f0414f552aebbf087ffa1ee892777cc9fb29ba9836cab4f5f65b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7cf2053dc80e501e5c0cf9755da15df707dcf922f5afb9d4bff62c5cd778e02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83e19267ed4940b2f1b5831d712e193ea56105d1d5d5277bb2300f4cf8df45fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "41fc9a7fbc8b4314e4732287613fbcb653afa01960786781f66af564c4828c5a"
    sha256 cellar: :any_skip_relocation, ventura:       "041d9131b78280d3e2b11a4a1c01bed36b6ed74c637c5229b43635752225b36c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d67ffd7afb7f73d2b6cbb7e6dac11baf060f95569e4453ae3f9bd2c33e522d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a058051f645a93d9f5c9eb5f18adad0eea699259b173873d077d6464211d0b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/goku --target https://httpbin.org/get")
    assert_match "kamehameha to https://httpbin.org/get with 1 concurrent clients and 1 total iterations", output

    assert_match version.to_s, shell_output("#{bin}/goku --version")
  end
end

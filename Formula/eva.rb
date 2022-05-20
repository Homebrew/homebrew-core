class Eva < Formula
  desc "Calculator REPL, similar to bc(1)"
  homepage "https://github.com/NerdyPepper/eva/"
  url "https://github.com/NerdyPepper/eva/archive/v0.3.0.tar.gz"
  sha256 "05e2cdcfd91e6abef91cb01ad3074583b8289f6e74054e070bfbf6a4e684865e"
  license "MIT"
  head "https://github.com/NerdyPepper/eva.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f57e5a6318ce5885415bd7bb44246fc115df0159c9576ed7c181cc0f7c9e7d5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2116a5a6e1a5a7bd08b01fcb8020565f4144bf9e73a95bad3955a4ddd6e1a41"
    sha256 cellar: :any_skip_relocation, monterey:       "7879b80f272a66dfbd720ff962e7e06486520f220e48b792deb93acbe2147393"
    sha256 cellar: :any_skip_relocation, big_sur:        "d08201d6c431e6663c8044004b31d3a581b3f9ae15c29aa47d0db6f4c913a81e"
    sha256 cellar: :any_skip_relocation, catalina:       "c6fa72af2cf3d0def023fedfd53d9e9d9235d45bab4f3c2f2bed92811cb8baac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae6f7369bc50480893ae64685774ade66ba56b185eead7fba5faa0863ba438b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "6.0", shell_output("#{bin}/eva '2 + abs(-4)'").strip
  end
end

class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "67d4e4f52b73d968e2c2591a02b692cba2ecb065a4621ea048cf688a0f36e965"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bc957c89bfce768d856e28561eef81ffea3ea7f5eb57f08097eb9eb493fe64d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a9c60d5c58d94602c07e3c65c6bf30aaa5ea0be3a27d7495b01e6fe4361ee4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7004b6aac45ac8e4be16db7f7bdb61bc9df16b5d1d229425b0ac495c4e53a93"
    sha256 cellar: :any_skip_relocation, ventura:        "68f18dc9d02a109f23f6707c5f7a61f23b55f08e8484be2fbaa01360dfd204a4"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d3cd0a288e5dd9770a37ec565401fc0a9d20003079b23f0d192c6d6c906621"
    sha256 cellar: :any_skip_relocation, big_sur:        "20538da5fa82bfab4fb5c8e0f20bc4c0b52b59af7564e3c30c1b045c6f9eaaed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec974fdb3bd6041676abcff3ab2aba6852f39ce4de7419ef4d37609266f4d523"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/et")
  end
end

class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "78a63a16c6370270aaf4c2d5e606aa05d738950b4c73922e2169b4cefc7ab760"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9511747c20ba6fdd9d30ce5a8966add59b850792bd69c625c3c308a01450ac89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9511747c20ba6fdd9d30ce5a8966add59b850792bd69c625c3c308a01450ac89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9511747c20ba6fdd9d30ce5a8966add59b850792bd69c625c3c308a01450ac89"
    sha256 cellar: :any_skip_relocation, ventura:        "0960696a7d48eb9214872d9f54fa9ef2f465b3296e9213b5a0a0ebc61802c86d"
    sha256 cellar: :any_skip_relocation, monterey:       "0960696a7d48eb9214872d9f54fa9ef2f465b3296e9213b5a0a0ebc61802c86d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0960696a7d48eb9214872d9f54fa9ef2f465b3296e9213b5a0a0ebc61802c86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b34aab2089204882ea2c02b0beb0595a92e282b7fc5d1dd3f10a785cf99d37"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end

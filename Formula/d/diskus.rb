class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "64b1b2e397ef4de81ea20274f98ec418b0fe19b025860e33beaba5494d3b8bd1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5fe60b671ed1870ee2ad322bc5500e294d8f53fb0c73dca1ba2c740ef02c01c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28c1375f94ba0ff11a36e06628b22d49b76fa5f565c8a09d91fd346b7a60c36b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17eeae141efc2ea4eb096bcad53246a699bb486fe1b70cbd3e0530b4ea36ea69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b851bd62c52e63a8c583eda93cdbb49efe75295f55a2811cf6d9cd7e18359f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c07b7ab1808da13bf85de3224a240012ca31fb007a2b66db3987499681994ff6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c50d69fb03e11b072f89a179ea137e143388f1b2e74e9811f6f719d6eb5ce0c5"
    sha256 cellar: :any_skip_relocation, ventura:        "f9b0c91217bee8c3b6b734bbf781315219a91f6ac62cb21e56ee1d190e8c65c8"
    sha256 cellar: :any_skip_relocation, monterey:       "6d0d71a9315253cbf3dc7aeaa7ecb0bfd4d2d26773d97f530a4b95fd3a2ffa35"
    sha256 cellar: :any_skip_relocation, big_sur:        "c823e41546c43c955d5756e22f098188154f7875af6a834794278e88a100d55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee19ac082cfff4ff93a5f007efc0eccfa07e2f87bdb1c5df4a949056808dc43"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/diskus.1"
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match "4096", output
  end
end

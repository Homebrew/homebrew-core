class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.6.0.tar.gz"
  sha256 "5b22932e1dea586ead051a09a4c416e538c29c85d1782718e4652415e59884e8"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6323a6fbb6e9b3d66ec07217122e4ce547b7aadd8c7fba32bc5c0e79d77a51d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a55d70b4064716b248e44daf899e957a715875ff88764c874176655242ab208"
    sha256 cellar: :any_skip_relocation, monterey:       "ba1b1478b071fd11d549982503d2987f71c0b59b5d342803136e25d9840cfcd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "da7dac8a2ecfd908021e6124f8224172a681577c6ff0d19c9f9d1a38218fc7ef"
    sha256 cellar: :any_skip_relocation, catalina:       "cb8c5abac85406d54638a002aaab9aaafbd5fc267dfc5283596a5e7f520d5d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b945916a35955cfc33a9926e91e349384373a8bc05f7631a7a2376807cbfdb3d"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    cd "leaf-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end

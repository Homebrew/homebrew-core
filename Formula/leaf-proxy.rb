class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.9.2.tar.gz"
  sha256 "7ab7953d7e97acc706532bbb650dd09587c415404d79f1cb5030d1ea94130f90"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86f7224ef8c362a053dc10a803fbd0572910f6922e675b1ea8518998e847f83e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccecfb71f0fc2151c4d9614a0bf17a3983009420285d1d20e2fdbcc78a324527"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7deee90af344f64a07ed4016472d329915a3037948183bf252465d83f0e6b44"
    sha256 cellar: :any_skip_relocation, ventura:        "ad14d7bfd89b198c1aa8bd543e4a8ef18791c6c1c234179c3b765cba57af86b0"
    sha256 cellar: :any_skip_relocation, monterey:       "d5f6b6d4bcfe8d09a56b2a0d3328fae771b28a64dd94c19a482d88c4921801be"
    sha256 cellar: :any_skip_relocation, big_sur:        "a76ed819f87023312b985a2277cc68537e9dca3b25c2b0ea1e911798f6bd343f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8141e92691fe8173f061e194ec2869f7ad37cd097ef2dad42d28b79dc1a3007"
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

class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.7.1.tar.gz"
  sha256 "6aed2e706ee5e1d631766288d5c7b0211f00a0892670b505fdea944834a64162"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de37957630021ce2ebee575813a57fdb95c85582141745f9f5b9a2173a26b02b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089b35b83585be79d9b12e828631105d9d2f6621d9cb39cf6345e7ee347e2ce1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8e81f59b2beafe5bca7f0ea95cb425a10a35f5f0d5d6694c840ed30160753a5"
    sha256 cellar: :any_skip_relocation, ventura:        "1caa577ff36a7188a7e759bf88ebec9e0693e159e084ffd8a9ca07d3cb06f674"
    sha256 cellar: :any_skip_relocation, monterey:       "fe3833ca3889e965fbd925e53a176844d0d3cf17b2ba30f80cdf1715538a9911"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bb2fdd86ef8955a96f5f034839e8febc6a485485b181ce753aee66a165d66a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38687d9fc2eb1bd29fdd5399678e70a0d92a5549d64f96e30ad55e00451741e5"
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

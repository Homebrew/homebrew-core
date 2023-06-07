class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.9.1.tar.gz"
  sha256 "bcf12e7a99f7345e73c11011b4b92301e7b32081cb07cb469c6c610a0d186746"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea8b7e387ce7958dcfcaf68006e21621cf31b253e22097c82d4a47594359e067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "305ba56e1815cca7df6c9131577b8714b195e536bb143040eaf106c6b3855691"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aadac253148b41d84e6bf5c9e174bc6c698175f60f437178ad358f35a76d6ac2"
    sha256 cellar: :any_skip_relocation, ventura:        "59b729d57f717f34af8bed48864d96c8893ea47686843e4f4e62656f547973d4"
    sha256 cellar: :any_skip_relocation, monterey:       "c2350cb67edd2393db703ad275d4f401720197ff6fdadf186d2340ec96be2461"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c63e153b5ecf2b4243b978d03543cdf0cd65daeb49cad1c43a2f92b9671e51c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6da1f808bf09bbc1eb48d107b823a9c7cac2b2da6fe325578280ad85f340f67"
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

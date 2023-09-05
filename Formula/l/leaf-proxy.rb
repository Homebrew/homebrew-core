class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.9.3.tar.gz"
  sha256 "8b89f6dc22ae0c232b1a02a47ad08d6cb0b50cebdbbe1f21a746e830862263dd"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33134c5e08ec289676bd1498b66abedddd9de326a7a87fd91fef768396a17782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfb7bccd87d2fa3baa5d0122df715ce9064757e24a0d0ef01aca54f67e4f1dbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bac0be377310a0084b824e3b7c1f739315aa4e47c2146f8ebc181c08cc1710c5"
    sha256 cellar: :any_skip_relocation, ventura:        "aa9a5500d30564207ae2c6fcc333d4d26d26bea777f2af7565dbb13b922fd6e8"
    sha256 cellar: :any_skip_relocation, monterey:       "0cc83e1d7a894991a9cd0785eae838f073c97c1b87daf15c7e54a7bcfede05f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bae8b2da44d6c109a114283a514f210c92f6612fd87f7a0e136b6403afd8bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "921bc62a8d032d4e9855cbbfc2153b351cdba86e86118d304f7914173eaf5bd1"
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

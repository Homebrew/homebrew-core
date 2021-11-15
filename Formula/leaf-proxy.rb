class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.3.1.tar.gz"
  sha256 "895057e2424a8b99c2fc330a8b9f34895a377d7fcff5d5fb7b867d357a3bdd83"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "008f26d03671d662a26bc67c6e039f0037a75b81946b9136fe90a5df3f440102"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7436395fb5eb5616771b7b521d8abd053f28b6b370e3244220a78ef3cae7a602"
    sha256 cellar: :any_skip_relocation, monterey:       "f927d6568e402539b7fc7a3851a05e089f48957ebab3c07f441e8c64c8d46c7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3acdb89d85419f3f767b19782bd3442c74baad9b0527471ab83bd9f74efa8dd9"
    sha256 cellar: :any_skip_relocation, catalina:       "31c45ca626144ad34a3bcf09440077cbaeb793851538e2046c581122f378ebe9"
    sha256 cellar: :any_skip_relocation, mojave:         "e0ea5b75bd333e98c716f9f9782aadb47e4e8d9c6b0e8f087f782eb8c67a58bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9473c11cdbfee47a2c7a8f6b8b803413a48f135378c747ac74de4d12dedf5a0c"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  resource "lwip" do
    url "https://github.com/eycorsican/lwip-leaf.git",
        revision: "86632e2747c926a75d32be8bd9af059aa38ae75e"
  end

  patch do
    url "https://github.com/eycorsican/leaf/commit/cfaf9736f42cd7c4e6eb6f3b696d0343834aec7c.patch?full_index=1"
    sha256 "4403b66732e84d9faedd5a7dae7b32caa32a46099a63af22139640f30a66b3ed"
  end

  def install
    (buildpath/"leaf/src/proxy/tun/netstack/lwip").install resource("lwip")

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

    assert_match "dispatch to outbound SS failed", output
  end
end

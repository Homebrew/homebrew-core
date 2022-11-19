class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.6.0.tar.gz"
  sha256 "5b22932e1dea586ead051a09a4c416e538c29c85d1782718e4652415e59884e8"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e99be2d32e40df7b3f32c039af20e9b750662c9afd4bca18e5d286133d100702"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e90f6d4c260eb3bab88182c0cf7360e86f30b865a813bff0825c7d885e24c43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d355aebf0aad23fc9bb94a03bfefba8a1c8dec92c2f46b24735ce0ed281dbfdc"
    sha256 cellar: :any_skip_relocation, monterey:       "f1a13b5e3dbfcaaabc3d624282b872d29b74efaafaa3a8bd64be1d50b1d8b487"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f70f05afb9f60dae8a45a393927a26507a7aa14839073d1af0bb81685d22dc5"
    sha256 cellar: :any_skip_relocation, catalina:       "3044f6769b0ed5c003ad77c9ecd1ac30e7bc6943bb423481ee129d552eedbf72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d961c8bda1fc66585b47492e3efc427602dbf91b7be5775f3b2a32e464883e4"
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

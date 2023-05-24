class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.9.0.tar.gz"
  sha256 "443ece8879de7da9dcd10b2fb35be178f00069e9867ca925024a17749a9e1fd8"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c94d9323ea88ad56d9cd873a7b5ce7f7a6476aef5b80ac174e4e6cd5a73d1bed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3fc155165f5214ec2a9887192325904b531b57b29190a1b43a201bd84b62a54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "545513adc3df5212ccab593b91b02ac5a7d5f69241add15b1b744a58544c5015"
    sha256 cellar: :any_skip_relocation, ventura:        "f575b58f2c547de8f1d1dbc5c4c177afa1da4092eedd5b2b11cf90976af261ac"
    sha256 cellar: :any_skip_relocation, monterey:       "6870a44a0c8054908a73dac13957f46127dbabfbee037dd96a78d3edb324c51c"
    sha256 cellar: :any_skip_relocation, big_sur:        "829df4fc3e2f9275ba035671596d7849927a08ff9f7644a4c535ea38f4c2eab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e368a232f57f3ae8752c7f2d13928bcef501b1d81f803cdff24ff361f319ec6"
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

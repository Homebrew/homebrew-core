class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.6.4.tar.gz"
  sha256 "1a54d59db80aee21cd5925bd8ef0829b91cd40b45f1259c6127388d35c5b9272"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4dda862c1575cac60eb9c2b4d0a5d5c1e3a539fe17a8bf6cf17375a3c49e4a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f2cf3d48701cdbd3d49317794920ad2e8d35f31a9032e54f1477cb5870470d9"
    sha256 cellar: :any_skip_relocation, monterey:       "3c15711285d89cab292bb97d24abbe52a4991910d84848e9029021306036d02a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bb5b6d7c35c212ea35850d87d1a9081540c78059ea157c8aa6acdfd5d9472e8"
    sha256 cellar: :any_skip_relocation, catalina:       "238e59674a89680c8e86c3269d1f85969429e28ce09baee9ce8e656d8ba35ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb32ee8f8cc1034758c738c1b0c0ad58c8365728ebee3441ca31ffa717187473"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end

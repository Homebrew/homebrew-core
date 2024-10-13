class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "0c54f558fd6883fb5e3bfe501a49d6076308e5b36f4bde93dc7a38b7cf09dd6f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9724e9148c74b8334e64b07d29cd6b6b6b09ba651e9db855fd8bf3cd01e74996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5ee8327047f2104cdb93e70d08499f37fdfc5143b6aa32ca0c910855ff0a911"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bc512a0b33922ce5bd1092debc7e8c8cede5565e0cd066b7c17e6afbc71c40f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f1def9b230382b6f21ede92b192a7ad1a482b5fb5e7cdd53dd2c8945094bc0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "058f45352509e266f7d48361227bc5109c770e835ba0f3f846e395c3599235a1"
    sha256 cellar: :any_skip_relocation, ventura:        "ca22f7e3686d0aa542157ba3900fb2300826e031bbcfe34b552a565dfaadedf0"
    sha256 cellar: :any_skip_relocation, monterey:       "bf071ac2b9bb988dcc04693e8b3cf711c90c9b4ab132a111bcfa85e3528422de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9a749655c9f1c27ed242bcf016dff84afdd88e9a828a065d48acb43209c5bc"
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

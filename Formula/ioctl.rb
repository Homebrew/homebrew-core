class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.3.0.tar.gz"
  sha256 "2b96cab6a639408906db5e5ccac6291918a8914f3c2de1c47f32bb70f5f08022"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ede4452b41646692124896dfa67e2cf1105acc0b533a63ccf79f4194672da998"
    sha256 cellar: :any_skip_relocation, big_sur:       "afde317c9b4b81e9c6b2a924fdcdf7477db615e259a11bdd03c19b41a52b241c"
    sha256 cellar: :any_skip_relocation, catalina:      "0784f529b77ada501891a036ee832afb5385d73ff0305d37201092bb6ade56f2"
    sha256 cellar: :any_skip_relocation, mojave:        "11c057ee8397d140eadd7eab3dcb56a3f4555e77efe71f984ed30501bd5b13d5"
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

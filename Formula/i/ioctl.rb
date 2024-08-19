class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "8e6ecf6be602e55cf8466dc3b0f93205c0415cff96323fa7adc2bc05f31d4841"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2667557b85cfec4de6989463be4686e3601190be01575c413502bb5c5b5f4220"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "782f730775f75783af009de583f27876626fc42af2bf5e8aca99a65d71e4d197"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4f429eaa149a85c9f4bb9a9b8031e37f8ccf3a3142f1f54cdb6fdcb3684f4fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "605a6555c8f4ec5dcfc4a581dc193d85751c797c61e2f479dcf1cfc0657b18f2"
    sha256 cellar: :any_skip_relocation, ventura:        "9871725f97acad026950e73aea185826c68026302e8b84b774f6ddc3bc3370de"
    sha256 cellar: :any_skip_relocation, monterey:       "fdafaa2780a7e8873c840ddd775b9e2d9a7ac7ab53abcd367b972be02e44f032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9f7135aa4a7f4fac26336224ce9c4a2deddfef40271da88f8e4ec8e4b24531d"
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

class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.11.2.tar.gz"
  sha256 "05b67090cf5aaddc5600582e870412d29c1316429dde3410817b3c48bd94f2b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17973439e54066a985c8b3c34610438fd4f5e78325d08ecef13bafcae0f2326f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39bf5d462acf1e96d4af992a6afc4154631097803a8afc09901c238ecb628b3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4be1b8067df78f72b807f6603705a21e4bb41eb83cf27f196ac26c5fca81001"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb69523fa280fa5f3d3b51e003551bf7b9ff15ecad18b8d225a34084b810eaa3"
    sha256 cellar: :any_skip_relocation, ventura:        "df753a6cba9a8991d92ea8ca8ed1e3375e6ff585c6a9075cb02b4448694f3e29"
    sha256 cellar: :any_skip_relocation, monterey:       "bdc12d17f10110c99b052dd9092ade4dbd29f08bc4d41d3ba182267545c4f517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9921a03ce146077fd8f4b83153d5f7adbabbdc34de37423c649df16e680d2953"
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

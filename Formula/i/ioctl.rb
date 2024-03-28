class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "7ba82d03f51f46355230c14f9d68e523130dd6706d255cda6aec81cbd73ff59e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd687f31cda96cf0f517a7dbf297f7e264d006358802fea5afb60c6c90bbfa15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebb4eb5e93a6d7866c82f48c42ba6c985b40c89dabf87d54bc209322ccfa451c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b90848a8fb8f6eb0c50cc676a87c937b3a7a9496bf71efeb23cf8a00d9646c4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5dd0b4c64532f22962ffcaa410dcf313acea78cd5dcbb259879a08781d63230"
    sha256 cellar: :any_skip_relocation, ventura:        "aa263a7d4ce510d6227a8086fa4edf162e985ee2fe4b5b5afb51966e37fd48cc"
    sha256 cellar: :any_skip_relocation, monterey:       "bccf1babdfd6d59e501dd8326ed5d0853df8bb310b9d63e2d60ce217946bf659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73f902d1e89bbfdd36b7f3af75039b2c581db37abec1706aa60b97993f364951"
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

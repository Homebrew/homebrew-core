class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "48d69813363c0236cd3ee24ec71f96bd404e6f11ed09264d37172d9000d5ebb8"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d1c5fa6ea9a5dfe005927f4d4a71786baa81b4c40f8f2fe5a3a144f1a63dfa6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59614ba0b594cdd14bf01f9b4b0a57c15c93c17fd2765b70403ba3599cc6d213"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e475ef023c121d74a47f396118118f967a5e796f288eae7e7a4a643b1718a6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67233f93a4169d346b05651428f366fb1cbcc6a727afda2caf59c641f0d21e72"
    sha256 cellar: :any_skip_relocation, sonoma:         "703a341778e74c1057337b132239281cbb56d5a4a215c897a7080aa8e0ab372a"
    sha256 cellar: :any_skip_relocation, ventura:        "c03c7f073c04dc754198f756c4a3bd18fd629e5609c358aab4c76bc1f885f481"
    sha256 cellar: :any_skip_relocation, monterey:       "f62101b1ff75db46f2a15d9eba914fe8b6735a459849483aa18144539188ddbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9208c17030923067a553bda48f6dff91ab20e71e8a07c4cdd04c82d4e507b660"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end

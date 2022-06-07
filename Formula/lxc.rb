class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.2.tar.gz"
  sha256 "e22d2b34a1848d33b2080b2b1c82355afb6d36fdfe49e67f44b3749edbc02e4c"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e6286afca19e897a62e10b6313305a4049fd72a5431469db792f7b37dbc6fd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cebd6ab8b9b1df8d991ef8a5ee7e4e8371d2c79e6d61341dae1a349e1966fc2"
    sha256 cellar: :any_skip_relocation, monterey:       "b42554626fec692903613de96b4152ac12d8128af68958a6d183362a41d24dc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "aac03f613d7c69420b3b29e139f98977660cd8854d845cc4e22a270aa7e04544"
    sha256 cellar: :any_skip_relocation, catalina:       "10144d3bd53a80ea865dfa652bddb6f2626cf6788a36dc75cd2f0e55f3d50940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e0e33a85c043872b2fa48243d6dda562e8e3089ab95fabfd388cd132c7ec6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end

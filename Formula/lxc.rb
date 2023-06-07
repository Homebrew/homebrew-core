class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.14.tar.gz"
  sha256 "12d559d20f4b0fa75603bd3f13501dfd15898dbbeb033536845de7e827533011"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88bd380161b47739cf88fc289b02573257b3da1591cec551747dcac25281b782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88bd380161b47739cf88fc289b02573257b3da1591cec551747dcac25281b782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88bd380161b47739cf88fc289b02573257b3da1591cec551747dcac25281b782"
    sha256 cellar: :any_skip_relocation, ventura:        "ade9f6985affea2a4a41eb55e6d4342d22a668ad1b63413cc9999234ce5776df"
    sha256 cellar: :any_skip_relocation, monterey:       "ade9f6985affea2a4a41eb55e6d4342d22a668ad1b63413cc9999234ce5776df"
    sha256 cellar: :any_skip_relocation, big_sur:        "ade9f6985affea2a4a41eb55e6d4342d22a668ad1b63413cc9999234ce5776df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6deaca29dfba2764741996d799704851fc134a4c7733ed5d489b50aa0ede34be"
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

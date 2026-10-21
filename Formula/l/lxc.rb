class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/archive/refs/tags/lxd-6.10.0.tar.gz"
  sha256 "4ede1d19dc6980234e1d8d68c74b09fe5631d7cac1b69081937dca42995da994"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lxd-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "282193436ef282895b84e42ddb64cf58e47cf59392e3b4781cdd1b981d9ce214"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "282193436ef282895b84e42ddb64cf58e47cf59392e3b4781cdd1b981d9ce214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "282193436ef282895b84e42ddb64cf58e47cf59392e3b4781cdd1b981d9ce214"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7e88613b3d095da9b232fd807458a691624bef005534ce2c1b8ee367bf38e015"
    sha256 cellar: :any,                 x86_64_linux:      "2f113c483b8755802334a0784900e499db1cc2f9829dd85d2e7a2525c2b98152"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./lxc"

    generate_completions_from_executable(bin/"lxc", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end

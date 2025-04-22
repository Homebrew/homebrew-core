class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.3/lxd-6.3.tar.gz"
  sha256 "68b379e94884f859fbfe078e4c0a46322ffd6f23209fa0b28d936676e7eada4d"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e959fd595d3b3a797f4eeb8bf8f4407bd2df3fb268fb638cc8db154c9c9a6127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e959fd595d3b3a797f4eeb8bf8f4407bd2df3fb268fb638cc8db154c9c9a6127"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e959fd595d3b3a797f4eeb8bf8f4407bd2df3fb268fb638cc8db154c9c9a6127"
    sha256 cellar: :any_skip_relocation, sonoma:        "53c3fb571b80c2fb5b093bc32ed2502631f65cd0cab1ba1bf2b1917ae6163e3d"
    sha256 cellar: :any_skip_relocation, ventura:       "53c3fb571b80c2fb5b093bc32ed2502631f65cd0cab1ba1bf2b1917ae6163e3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68b507578c65c458e8fd003351ed5027c867ae978067f41ec0a2b34b3f2451c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da7dc438ebb5bb7d3941f69c550f92a689f64ec460db812871d619fd11a05e4c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"

    generate_completions_from_executable(bin/"lxc", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end

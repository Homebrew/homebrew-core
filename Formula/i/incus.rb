class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-0.5.1.tar.xz"
  sha256 "99621ccf3f9edc10203ec29290f6686fcfd5e71be8fa9155dec051d3ff00d9f1"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "770a693c8e8eb6f3d3d7bd01d9bdd7ac847e2382f0acfa653777e35838b3d357"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71f77a312c6863f6299bfb180774dd291229940b04bb2bff05fcf1bb4a2b4d06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94631e777f133f207c30245d9594a1694dfc128baf7f32c1db7c1ebb39d146c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "006e0f312b3e99ec71f9a83c5fa8f2107f67f2f625adf2e0888a3c5f7185ca25"
    sha256 cellar: :any_skip_relocation, ventura:        "783e9e6a550509fd65729b9119758faa9ddfd5e7c965f1c66242717c7bfab7a5"
    sha256 cellar: :any_skip_relocation, monterey:       "9944923ad09d17dcbd4f5608e13cb17b5e2c3cc172459ea0aba6db613f13b3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03ca2db75a25c0657a43d001dc805d40d43f95304d4444c866f163b828ac5ad9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end

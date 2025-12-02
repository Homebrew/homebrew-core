class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.6/lxd-6.6.tar.gz"
  sha256 "2ddfa88441ef1f4f1f0b49cce11285620e34f3245e792f22034a688f3c07233a"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de746f141acbdaa3ecb9858a7229e9dc4b4cbfe64962834f22db07b32a2f04ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de746f141acbdaa3ecb9858a7229e9dc4b4cbfe64962834f22db07b32a2f04ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de746f141acbdaa3ecb9858a7229e9dc4b4cbfe64962834f22db07b32a2f04ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6900c1d192281f649915c603e0e79536ad21adc63acd621ce5cd19ef9505661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fb87b9fb0628ad16eaa59dd2e167ded804f6df542afdb81d1fa5d261d7c2dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bded123100fc22d53330a903b406065464ab6e48063a0a80f4ad8bac50aa9b7f"
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

class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "57030eb5ea26d33fc24a089e21d46444b7fa3df50856e5f56ffe801cbeee26d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1cde8e2a8a07a3e314787b8bb564e93c059534b522bf18f15839060cb88e30f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dce10214b891d77c15296d9076f3aab22e48dfe9a4c01f03928376133ce4761"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5f7c12e7d04f3c9a09aa410b5ec145eee9cddc50741342ce7c3b514f7e3c7f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "834c5be97bb72adeab26844dc48ed9042c6ecdbb9641a2601519c256b426d4d0"
    sha256 cellar: :any_skip_relocation, ventura:        "ff8e10b565b53c2bf0e0fff9f7d5eb02ca444dc4c618fede76e806c1a4e3f681"
    sha256 cellar: :any_skip_relocation, monterey:       "aeaf5e295285108b6403c6190c6957019d87e4e51b02dd4a981c17eb7ce8fd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70fa83f4c049706a3e25753c13793a4f4e6b35fe7bd357d6182fac7022057f05"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end

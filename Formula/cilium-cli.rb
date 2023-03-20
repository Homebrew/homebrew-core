class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "4eeb6e38ef9ae7b320daf8bbdb312bb0dfcb4c535d9acd5560b69e71b2be413b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e106df616edc4e6ea924119784122fedbe2652d1cf91a3753fe5c1e7552b680"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7289f2eecf21377bd6484124960193564e45a62c62fcced497e560b04bf320b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d21b8542dd36fd3e442214aa824307f6dd7b084b52825bd114a134c4cf96df89"
    sha256 cellar: :any_skip_relocation, ventura:        "d7964caff896875cf05e6202a5f7eebdbb342cb4fe315574b92026d78b77710e"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c17a4d1e5ab588b36366f1a53ba2bb8226004ab6a7ea5bd81046d33b97b70a"
    sha256 cellar: :any_skip_relocation, big_sur:        "13bf1bf665935f190c2a5f91c9f19cff3013d2ccccd68f770a12b6a65f925d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e51b17f645c03f9f1ab7a618680b4880470021085072ce3be40412bc3e92837c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end

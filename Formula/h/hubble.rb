class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "294d3cdf79db7e6a1930007a60b67c719db867aab7f106190f5b797fa98c875e"
  license "Apache-2.0"
  head "https://github.com/cilium/hubble.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15a05af2fe3d35be2b25f0f91e4ba9bf42ebdb63b6a2a21233269fca2b967409"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b37e3d99df342a13b38f27b06088926e7653b199c6a1a007e464088909d8a24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c3ec5b97f05511c512e4e07166b7dd133965d97485fdf08fc39f08b908a8a08"
    sha256 cellar: :any_skip_relocation, sonoma:        "6586ffb82d4f9260d412b9394b6e5b45ceed6b3b2670167b8f7a1bc3c08964a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0318082aaab8c9828fe07748bbf35cc112654635f9d38b358799a97cef2acf9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "125080b4d2f4d6fabf25922579fbbae209e19eea9d396434e1590fe34f096762"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
    assert_match version.to_s, shell_output("#{bin}/hubble version")
  end
end

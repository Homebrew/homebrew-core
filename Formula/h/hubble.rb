class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "5c48a34a2e3ebd8b0b9e2c97991aea3765bc4c754a573ac5e77cf273c18d48a9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58d4cb6cbdbb904ff69d121952ccbb455ba0a1ec8e6e4db3ffff6844e248a4a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88efcf64cbc3a46826bc123b8477cee5ce8984ba74bfad3997f110f2d75b7db1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1563dd7c76ba9493be4e5af7799dc72becb2567a46b8920766f49922363f00ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "f571762aec13934cab39afd4283f4111284b1ae1d1aed13857a0448df2ca6ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "623c7b52005a50784c97d3796012afa82f122c2830b5c2bf2f5f5c65a41791bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15fbbfb6c90d55d6c75dafdc311944b5d3aba47c8877f27bdebb38066e531aa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
    assert_match version.to_s, shell_output("#{bin}/hubble version")
  end
end

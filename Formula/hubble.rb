class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4b113cd0b89b57d6e59d3596ede6c04a731c00b3fbff8c2641808bcb31b5faa9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9951a81a642354bd455e52e373e05357721b2bf88c83f143163d84c337fd3688"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f1a4a5f613c7a9e5b08d9d973a1123abce1d00f9c4a9488b3eea1b4af9147eb"
    sha256 cellar: :any_skip_relocation, monterey:       "af33f9f06d83688c492f4d39ddab38fd62804d571591c41a7b9f42d04fc238ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "88c9ec5cd0ae74188b81265bc7aa0280a591485f83633ee347ea3a21293ef36a"
    sha256 cellar: :any_skip_relocation, catalina:       "c080bc80f4b0054623252480a8432d146ae065bf12b57e96323d1ca9c15eb41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4dbc77d9cae59b29a3a503298be9cf3799fbc678d5c35f9732554d0a3246045"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"hubble", "completion", "bash")
    (bash_completion/"hubble").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"hubble", "completion", "zsh")
    (zsh_completion/"_hubble").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"hubble", "completion", "fish")
    (fish_completion/"hubble.fish").write fish_output
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end

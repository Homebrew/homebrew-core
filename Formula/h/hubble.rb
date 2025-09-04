class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "29f4a452a360829a184d5e20b4d6c54fc96c982f91fe3569cd26b0fec35cf010"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df2aa733b3749805b6fd4773f6e7e8cbd22e459e1b494daf9c437b057225fb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32a248eb9d3635af481c3a28780a50800dc93dfcd4ccd0d514e9e64be7f22c8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17ef999a277a36b81b58004a102d4501514ec936b63fc4ec9bd92882189601e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "766f5138a0119e9ad3e84c31bdc290eb6b4956624978a4cae69d6380d6828160"
    sha256 cellar: :any_skip_relocation, ventura:       "c9430cdda0c5f413ffda9c32ae4329bef6811ffb347caca6d03c4476a25dd23a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb7573d02547c359470a54d056437a26c951127868f0bae8d1614681f3170984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d487082f3d109abe02f775b69854c5a04059dcc6f67a3ea05027e533fd453dc4"
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

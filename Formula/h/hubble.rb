class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "88f5851ed98948464272895b70a620b5486d3d2792a11721178f832cdd69eec3"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd4b6815e689cd4536cef004ce1074b8bab09558cf7563a2c30fa879a4cb26ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc623022cbdeb79368535401061a5ecb67480295b5d08c573dce4aa00ad9b7b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53e575489464d4096d103c76534c3117c1ea74e7f9e160cffb6b1f19a3ec196e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d549f7be6c09a2758c9c98fa77d8c31a29ba453662a7f1099099b371b7cabd45"
    sha256 cellar: :any_skip_relocation, ventura:        "313f1a0cdc19642bbe30827dc6bbb47779140092aed74bbbd843687fce05ef3b"
    sha256 cellar: :any_skip_relocation, monterey:       "69f00cb33219b1561d3fd8fe6dd4b84054479d0d6e6a3fc5e5c0be0d38d2982b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ee253f17423a819fea7fdbcffc1f410d55ac63ead405a8a71d6dc86d5193d19"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end

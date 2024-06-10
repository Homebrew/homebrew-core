class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "67cfcebbeade12d1b0ed7ab8b623186cf0cd0ab9fd8a82677ab7c06c9bb6da20"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f03bd85920c52a3aa9c3593f13ce9b9189e4a634dce594b094c9edf37c08f20e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b74804b2da2c9131fe318903e0a1c33f4e3bb73527e24a850b959cdccb2a7277"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94e6aa577d8937f3af9ff35908dd558e473c51fdc45beae562b89d2f8cc87a7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b20452ebe8c5e309ca95ff3964bc82c9b94dd1afeb5f34948965c99101a0a6e"
    sha256 cellar: :any_skip_relocation, ventura:        "06e21f3b27c436288889c3e6ac328cadd4d5fcb158eaf75170a1bd96d588ee4b"
    sha256 cellar: :any_skip_relocation, monterey:       "13599da527babfe5cadf37571177d68f43b135bc8efcf9626840c01026317503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b1ff4204e8261508c79bf46608a36c7708373d32fb023c69f801903a2f399a"
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

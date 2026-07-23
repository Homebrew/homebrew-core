class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "82e8d062e8f2cfeecaeda19f300350d6b453d6d1584f2111f6a7763722994366"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbf1cbfa6b68d9458103f003dff66a51a330034ddb975ed51c0768509de06559"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9f633516425227d7afef82760ec9fc0cae8fc59611dbd75e63305927d613494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db96a45f36e4b8a08a6f092546e368981ab31f013782300a71c4e553fed18bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b4f6126b34e20b91ba5880e588bd3aa228b3dadad0804d84d7c99a60d6c7485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c657d5b915c40b55be47b9bceeb90761092554dd77f163d9433253daf19faa"
    sha256 cellar: :any,                 x86_64_linux:  "1826c0a4e0d4ba63ea70c14a077357fcd73d2eb4ad24d2b39ffe27901d281bf8"
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

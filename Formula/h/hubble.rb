class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "4e887b9cac16fc0c6bd2994d5549aa265fffcfd230e3533add1e46cae5b91a2b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0755e6f1d15f9e8578f1390147a90d01e34d267b1f23e4e7607864940c13bbad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da8881dc7a4d1e0f0a4e0fc1e56add72d360af55922a0a760ac97c14d71febfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a539fc95a498bb78f1d595b261392f53037548feaf469a8d2b1183eb41a929fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d37a6c7d2a58801c4a4714d29353f1f52995ac9286042e29955da2d527e75ac"
    sha256 cellar: :any_skip_relocation, ventura:        "4e7cd07974413143a66a82b22d8bb614ee50b281f508b0cbe632467cc88e67a5"
    sha256 cellar: :any_skip_relocation, monterey:       "e885a4e2124216391f90e0963b14cf887238d395bb02b2fee5d39d2ad83724ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f94ab66908226a85b323ce82c24e42015447edab70a7a04ca02a846863b861f2"
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

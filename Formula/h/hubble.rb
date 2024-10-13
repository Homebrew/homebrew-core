class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "d5d44116ee6c22d1c814dab43242d68b0a02834fdd9ca42473f81015f36d9284"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d1d2b715007f4935038c1595ab24a69e5bd7b993e59c6febdb98682ec7ba40a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d1d2b715007f4935038c1595ab24a69e5bd7b993e59c6febdb98682ec7ba40a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d1d2b715007f4935038c1595ab24a69e5bd7b993e59c6febdb98682ec7ba40a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7ae6fa125185bf2356b73713b03db8d9d2fd2b5326ab86dd5a22fb310a919e"
    sha256 cellar: :any_skip_relocation, ventura:       "7e7ae6fa125185bf2356b73713b03db8d9d2fd2b5326ab86dd5a22fb310a919e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233a21464756e2e7b6e63665d0b5525273457c9ada718f8da86639becf855fb7"
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

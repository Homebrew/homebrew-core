class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "f5111aedbf967b8953bbaf1d64a764093ff14cc62bdb803a879a393da22be74d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36f617cf80a286ea57e688f0333846c98555a709f1a8a151850257ee9526891c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec45194fa7ff5afd264e33e3f25ffab02520d530d3172d41109acdc3b0756eb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27ab29642d629af5101db5d15f18443d1baa0f76d4e0396eab1787a67438ce57"
    sha256 cellar: :any_skip_relocation, ventura:        "60a3be84b23e71341e156cc411527b96c16a5309240f96bfed1de3dc7f9c3c85"
    sha256 cellar: :any_skip_relocation, monterey:       "b0c3289f4324e129c0afb3b2ef8eded94e692161b3bd5d1727243b6be43b5dfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba4595d62190e506e8412479120451d50d1c5ee5dfc3be64c368d5b51ef9eaff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb9d69fcbc9de222c765b76c703dc9415454ee4551172d709c18f118f87221cd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end

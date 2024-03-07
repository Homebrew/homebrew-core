class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "357de695f83d875ad28088ba6d93c018f005b9527574cb948e647a9a0b78b954"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4258b3bf1bfe55cddf3776778d77380631bfe8382609d248e0e38526fc1b389"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4258b3bf1bfe55cddf3776778d77380631bfe8382609d248e0e38526fc1b389"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4258b3bf1bfe55cddf3776778d77380631bfe8382609d248e0e38526fc1b389"
    sha256 cellar: :any_skip_relocation, sonoma:         "89e5fbe0f3173964a1023f28bcccec088ef1e7e15b2d7c35403eaf4d9ac50447"
    sha256 cellar: :any_skip_relocation, ventura:        "89e5fbe0f3173964a1023f28bcccec088ef1e7e15b2d7c35403eaf4d9ac50447"
    sha256 cellar: :any_skip_relocation, monterey:       "89e5fbe0f3173964a1023f28bcccec088ef1e7e15b2d7c35403eaf4d9ac50447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9550be8dd7a496562dbc8f390c6af75a11a918abd7b75e476222d358576a4c83"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end

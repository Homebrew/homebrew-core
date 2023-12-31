class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.20",
      revision: "835bc868427f54cabf66a0176b8b69d3922dd47d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d14b66aed4e90ffeaeaa5901b590da6db9b935bbfb67daa6633cb4decac72c26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb2586a5529e5c039ae19e8427c0740f2d3f12b1f29e1a1088564f2f320fbb88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "105f790cb659fa0c10db9628680cc4707901fe407a14f2935e7779672fbe772b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d64d7c0370112f22ee753d5f758fc1f426a04b4781a7571cd14d4c6aa601b43"
    sha256 cellar: :any_skip_relocation, ventura:        "5b1927567fb951f9a6727e79cc7caac655154edf56985e16b0db87f87e22e065"
    sha256 cellar: :any_skip_relocation, monterey:       "7f818ff05959004f3bf8c4bcc351fc2cba4146eb5fd34d4ca7f14c7d7daeb3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcf9f460286b4bc5051234797ce7e6bc3ebbb88724667d7e62300238fd9aaef9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end

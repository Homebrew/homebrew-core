class ChartReleaser < Formula
  desc "Hosting Helm Charts via GitHub Pages and Releases"
  homepage "https://github.com/helm/chart-releaser/"
  url "https://github.com/helm/chart-releaser/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "eb0277025c5ab1e7281ad344e415b2721f1f3698c6a1f850cd42b1f1aae838b6"
  license "Apache-2.0"
  head "https://github.com/helm/chart-releaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6afbbab4243741ecbd5377f94a17f0287a6f05dcd10df599a344d4b3a36d6e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0d8d8d005096695d14cf0e472be9fa0a7b2992aa4b9fe1241570534c57d6554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "383abd2d763fc81d32b6755fd37dae0cac2b4c1a4b642a3f433fcf212ea53a1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d0c4d33d766d7e2320e8c113e2a3a595fc1b3c9da58687a764271b63a743fb6e"
    sha256 cellar: :any,                 x86_64_linux:      "aff737e3a6d106d85cd59792b225f599bd19084e7423945792e4990cb96b34f3"
  end

  depends_on "go" => :build
  depends_on "helm" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/helm/chart-releaser/cr/cmd.Version=#{version}
      -X github.com/helm/chart-releaser/cr/cmd.GitCommit=#{tap.user}
      -X github.com/helm/chart-releaser/cr/cmd.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cr"), "./cr"
    generate_completions_from_executable(bin/"cr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cr version")

    system "helm", "create", "testchart"
    system bin/"cr", "package", "--package-path", testpath/"packages", testpath/"testchart"
    assert_path_exists testpath/"packages/testchart-0.1.0.tgz"
  end
end

class ChartReleaser < Formula
  desc "Hosting Helm Charts via GitHub Pages and Releases"
  homepage "https://github.com/helm/chart-releaser/"
  url "https://github.com/helm/chart-releaser/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "288fd5a6c6b761312103f499a0e6a797f5ca11ae903f5ab88a6557712b962715"
  license "Apache-2.0"
  head "https://github.com/helm/chart-releaser.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1575d0e68f4af3ccd39b9822a3e8a8f207918c79f5072cdcb7458060cddd78a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f6da8ad253bc96f4cbedec034499969d4895d5549687497568ee3aa80133da4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f6aa9a1c49665848b24e0c8781e5d65bff802a5049f648bf5597bfe23f07093"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "614d3237b3fdb9d8ac7bdb1c8cb85b1e19557db65fd8636651412876753f4ba7"
    sha256 cellar: :any,                 x86_64_linux:      "429fada1249a2c3affafe69798e57ce9ab3f63c4552c3653526d06550053dba7"
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

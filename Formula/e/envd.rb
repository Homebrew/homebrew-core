class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "4524206b20e371507bfc4d7eaaa631188e6542132d47638280a641c1656071a4"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e27cc64092b3fae645f85cc04fbedb4544db7e66f850fc287c932aac058df287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "380655aaa5b9c458320bba15603fccaa8b37f97644ffdd2efb3be8d99a172709"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9670557698e24a077ff59e82056b210cf107ec8c458132969f0e5617f35304fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "12b5bfe20ad6451276b6c5f51a509d76a8655ae401246f3d72b46d877f8f3231"
    sha256 cellar: :any_skip_relocation, ventura:       "a760096210ca7768bb142e5529af18c416b3f69257bc7044219b18e96e45ccd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a078fe8d9d3ac1b0e3f91e988e98145d6f107483d531c2bf8b7f64ad0d44fc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "failed to list containers: Cannot connect to the Docker daemon"
    else
      "failed to list containers: permission denied while trying to connect to the Docker daemon"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end

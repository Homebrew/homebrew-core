class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.9.tar.gz"
  sha256 "8afc9a4ef6a2a7368b21fa361c98af46fba7ec7c69eef1ce61bc160d943279fe"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f18532aa983eba3df2742339dbcb019700945968c4861fcb80114f38ed287e76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f18532aa983eba3df2742339dbcb019700945968c4861fcb80114f38ed287e76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f18532aa983eba3df2742339dbcb019700945968c4861fcb80114f38ed287e76"
    sha256 cellar: :any_skip_relocation, ventura:        "6e8357ebc9a516c8d3d891c071fd5a20b81157cb08462c0635a8a65de296869c"
    sha256 cellar: :any_skip_relocation, monterey:       "6e8357ebc9a516c8d3d891c071fd5a20b81157cb08462c0635a8a65de296869c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e8357ebc9a516c8d3d891c071fd5a20b81157cb08462c0635a8a65de296869c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d36b057369b6fbd1970514f17a565c5e13c73e7504a54bb55761a0a05d76b2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{version}-#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end

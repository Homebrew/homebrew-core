class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v0.3.43.tar.gz"
  sha256 "588609b0573d2456359f63fed25bf36ba976b3da734e857e8ec98d6b30d56057"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0978e3423538e29d27ed86c2da51c0d25d8944ae22bef76412cbcb3b3afac897"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e541b643010ebb24de4375b7332d8bc8ee5a885b95ea206eab91beaa688da843"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d373c574bfacd7898d65228eafb8291ecf8f133a2ba2a2ddb647ab6aab4f33d"
    sha256 cellar: :any_skip_relocation, sonoma:         "67df1d61232aaf61ef9d27948add6b7b9cd73f0fa816b5e79ac730d88fc1559f"
    sha256 cellar: :any_skip_relocation, ventura:        "91e5c47862b1026e927c0f04eebaca800db147d5c206d0a70232c34e7ef302c1"
    sha256 cellar: :any_skip_relocation, monterey:       "495230314da79e6d6c0374c8bce9633eaf872e8dfff5486d35af8bbd18394cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d612c89a2d74fa9490cd1ad431438e61c380ceb3cdb228b5eb95acc3f0401ca2"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
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

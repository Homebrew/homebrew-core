class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.39.tar.gz"
  sha256 "d7f4c2f51d8c83f73b40e732640ee8cedf59f299f4a42011c3ead776f5db4b1c"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "110ee4d7152825be9a31a922e834228d564dfe3e1c62fc04df477743722dd9b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be14603d77cd79a3423d574668e555239a0224c668ac457b3a58c1910a0434b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19b1cc3db62907a28a37d1146b9ebe86bac1b2c41feeaac74b1ff1d4176ed426"
    sha256 cellar: :any_skip_relocation, ventura:        "1d6c3b1e94176f6d237dc05ed0aefb150a07cc35b0a7c7832fe521910e321c80"
    sha256 cellar: :any_skip_relocation, monterey:       "d9829325587a779703ea8565958e257d10141ff0f4b9b04aa79f4f478d597690"
    sha256 cellar: :any_skip_relocation, big_sur:        "12609b3f96df256e80853f6d24972376825225a5fed102e34c71772ee819f01b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b175c1064ea47ca3c561181e26f8f1dd2c5e22cfdd2c977dd9cfcdf3fc7114bd"
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
      "failed to list containers: Got permission denied while trying to connect to the Docker daemon"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end

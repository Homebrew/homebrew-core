class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.14.tar.gz"
  sha256 "c8ca3948060b8c1240c121bf2daa30448c2e60f2ac06568e7ce99c23cd37c2f8"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bf4a6447cf45f61f18881a72dd85d382168cd2e555e1144bf3c55672c2f56ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d12340f43e4538d03df3e6e81651937819d27a84039cf55046d89732cf96d36f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "379bbba767c0087fd084a1f8262e97039517d60ea98dca22be45140e7bde2c36"
    sha256 cellar: :any_skip_relocation, ventura:        "18c6f086ab6c54d75161aa58bed8d9dd04d45f1e0e59764ed044ae4df9770164"
    sha256 cellar: :any_skip_relocation, monterey:       "08a916eb84caffb8543e6bf51f8bfcb8fcdef9b208a4c1a872ce25b080dcdff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa3875777bcc00ef48069f5ce13a415deb00f20d416c3f890f1cb22f7da48c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee309c671fb3c128849fd85f328f7bd73efdd10d4dcd399c1db876c58f4a14c5"
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

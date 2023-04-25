class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.19.tar.gz"
  sha256 "3c2327fdb021e66e1d26fb1beef3be9f9e88c1cc2ecc5e6ddd0e95da4256e5b9"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbde1b16335f505dd78240432175a61e71388179525d3b8b5aec60f242e8b3df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ced1f58208d69e9c2d2c172e8b8a9a039b4fe92d59e8a64ebfc80e9ff0d498a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64641c5c44893688616b1c5771877f0c0b417b558e4ba5009c815ab2d55da7d2"
    sha256 cellar: :any_skip_relocation, ventura:        "364b112ca4b2b28dc9d0dbb6f98ff296717e8cd8aa6c3dd231f99efbb1ef193b"
    sha256 cellar: :any_skip_relocation, monterey:       "8f9488c5a205a14b0fd462618b75b0d34ad6140a54000b4b020c35120eabf8fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "15e59e87a682fcc3e08c1cb5b18642552016cb37c503f33f1ac970acc9a39d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "526f40e2ad9c62f03a0db58d07e3e10eef551dc32e5216418c6ffffad2f11ec4"
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

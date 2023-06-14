class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.25.tar.gz"
  sha256 "2d19188898c6fb3e7bfe0ff90ee7c3a774a9c6d9cb6e2b7ee5614ccaeba25b29"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d2ead8d0462a9b4affb3c004994fd7e0b5814a093abf953af06f1eeeaadea6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d2ead8d0462a9b4affb3c004994fd7e0b5814a093abf953af06f1eeeaadea6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d2ead8d0462a9b4affb3c004994fd7e0b5814a093abf953af06f1eeeaadea6d"
    sha256 cellar: :any_skip_relocation, ventura:        "58023c0dbde336cc7cee0f737e9c53df02f1e28f14b428c07702dea26c55f5c4"
    sha256 cellar: :any_skip_relocation, monterey:       "58023c0dbde336cc7cee0f737e9c53df02f1e28f14b428c07702dea26c55f5c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "58023c0dbde336cc7cee0f737e9c53df02f1e28f14b428c07702dea26c55f5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b15d8268437c4eed7c322c7ec5dc58bf0e5eb16df3c6152456e6afc616790b8"
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

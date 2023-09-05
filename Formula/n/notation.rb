class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c7e3a154cb132d17c72c9954e2c2144b5dd1781af69e9bfe25ec29916e2f01be"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dace95af3497540a4f288c26dad180ffcac605e39559bf7724543edefa7585be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf87f3ec5d3065299216fc05f675cd0c41706264209b83cf2d7f6dbc9bbc0e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b873594a2ef7d95385666669470fa850f25344354ab0b373b3d6455845f216ec"
    sha256 cellar: :any_skip_relocation, ventura:        "257bab825349099484695a235b9a380dd32d181bd270657c7e156a478ec0ab81"
    sha256 cellar: :any_skip_relocation, monterey:       "376ede052a69f5b98552106845090f262c263a7a9d2661bf166971fab32520ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "4178e3f434a7ae62b7bd6f5af5849a05e2f49680332e1678dc5fe2943cfbe4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e76d825c398991d20ba9e8243bf5cb6f1fbf4f9f1cefaccf70dfe183b5bf3a4"
  end

  depends_on "go" => :build

  def install
    project = "github.com/notaryproject/notation"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.Version=v#{version}
      -X #{project}/internal/version.GitCommit=#{tap.user}
      -X #{project}/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/notation"

    generate_completions_from_executable(bin/"notation", "completion")
  end

  test do
    assert_match "v#{version}+Homebrew", shell_output("#{bin}/notation version")

    assert_match "Successfully added #{tap.user}.crt to named store #{tap.user} of type ca",
      shell_output("#{bin}/notation cert generate-test --default '#{tap.user}'").strip
  end
end

class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c48884c17ac8608913efe1aaf736a6212ce109c2ba886b2a1dedda8abdd5ffab"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f1f8852bd2195d598da6a86e594790cd01c25302a00a1bfeee9bd9d70dda360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6a21bc661656cd79347c9fa3cade01ab45c8e6ab0e47f611246b0b279ebd0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "996506ee111508cd082f77153d9eac3e774ae430f8e34f697c7c73cb5ffeeacc"
    sha256 cellar: :any_skip_relocation, sonoma:        "efdb92e6412a34d8fbbbf4fee13f675dfffbaa4632d4acf25d724ada5bf1cc6e"
    sha256 cellar: :any_skip_relocation, ventura:       "8aa234357c07f4a5669624b5ba7945b052db1d4c0bf38e03d5c331c061030095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eead99367973994188c7a971fd64aa4a4642bdbfd8d22463d4203c9e034013d"
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
    generate_completions_from_executable(bin/"envd", "completion", "--no-install", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envd version --short")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    expected = /failed to list containers: (Cannot|permission denied while trying to) connect to the Docker daemon/
    assert_match expected, shell_output("#{bin}/envd env list 2>&1", 1)
  end
end

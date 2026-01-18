class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.105.0.tar.gz"
  sha256 "5a4757f820624a5e318ac6dbc7fb6ca5b82c09fb7f5c1179be111f6a28eb6a15"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c1d29f91eb483a930fd23abc7139ea6da3281c0b62f66f6c3c6039e1e079a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "228720792b2fb2fca9560c160fd60dff19c24f29c52b5b3404c4b994147219c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dbe22c64434a0cd7b8f946b79c5e7fe830a42f7d8a6cb52a66ac50744fc131f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f43f7733398df6dcab07ea5e976c3266969c805d2a3c1937ce9a7b15fb880c68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5afb90bee771410020809d3520b2e0d10a1e74823cdaaad36a12429e15949ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "419cb0f51e3004977828fb4365a42fbf2214f0b23c80cde498dc56c5539ac03b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end

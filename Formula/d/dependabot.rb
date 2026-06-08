class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.87.0.tar.gz"
  sha256 "2744f2264b2be5a1214ac0fe76bbe99e7df43eda90efd476f97a866d42db3db3"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f636871f198243f292bcdcf27c09dd3df47801190cc5058f2f17bf01a155d482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f636871f198243f292bcdcf27c09dd3df47801190cc5058f2f17bf01a155d482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f636871f198243f292bcdcf27c09dd3df47801190cc5058f2f17bf01a155d482"
    sha256 cellar: :any_skip_relocation, sonoma:        "020d83d96e215be81ff5832d75045c3efdc85df91bbaa08a3216a2917d8fc8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "542d8dc73994140823886fe4ded6317a4d73e351cc9d07b067cc85be17aaf798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c7f8081e05285ece133844ace7d920ee7f3298518fd7c4cc21c22b056d3653b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end

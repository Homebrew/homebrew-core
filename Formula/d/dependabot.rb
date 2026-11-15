class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.97.0.tar.gz"
  sha256 "c3823fe5c90b57b5dad4ea9f52c4f64113c5444be7bf1dfd2f05eb1376a9c459"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d19bc518e042af344106a4e7562deb1bf08a1e97acda87cba39e818b71abf20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d19bc518e042af344106a4e7562deb1bf08a1e97acda87cba39e818b71abf20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d19bc518e042af344106a4e7562deb1bf08a1e97acda87cba39e818b71abf20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de5c6d9a862157a6f6263cb87a4dde149b03d63844d13972bb26d8a0659602e9"
    sha256 cellar: :any,                 x86_64_linux:      "1ae0ca854f8288a828b6de9ab02b8fde16deef6d9f8d65688d50f6a06d1bf5dc"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}]
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

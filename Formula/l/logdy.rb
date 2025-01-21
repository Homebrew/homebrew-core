class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8ab02af3ad7e98006d86c27d4cc649063b4809d831445aad3028f2bbcc46ba1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4296d168c8a6c66083cb020645a7024291c344af7c1c24b672ae2e6f49a3103"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4296d168c8a6c66083cb020645a7024291c344af7c1c24b672ae2e6f49a3103"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4296d168c8a6c66083cb020645a7024291c344af7c1c24b672ae2e6f49a3103"
    sha256 cellar: :any_skip_relocation, sonoma:        "f91006a38c00c4976655af72266e022bac80480da6474c6951df7604840aad5a"
    sha256 cellar: :any_skip_relocation, ventura:       "f91006a38c00c4976655af72266e022bac80480da6474c6951df7604840aad5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41c282f95e279e2cc1d7388a95342f2601017ccba195b9f6417f7543b033797a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"logdy", "completion")
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}/logdy stdin --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end

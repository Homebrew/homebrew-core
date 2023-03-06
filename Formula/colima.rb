class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.5.4",
      revision: "feef4176f56a7dea487d43689317a9d7fe9de27e"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcee4fc61a611b0cde2e0fbd892898bef625683d53d18eb96310d40bdd9e4621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b626a8478e2533b4952324ba185e65db7b7c74a77f3ec657d703fb3f283dd31d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b626a8478e2533b4952324ba185e65db7b7c74a77f3ec657d703fb3f283dd31d"
    sha256 cellar: :any_skip_relocation, ventura:        "cde5603563b1a4ff4fa25ac45198477290b10809970390d08fff5d8d4d1620d9"
    sha256 cellar: :any_skip_relocation, monterey:       "4c2a257bb49b6e325bbac30712abff6b10b8fd969b7582e5accb740d538e39a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c2a257bb49b6e325bbac30712abff6b10b8fd969b7582e5accb740d538e39a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c76e2fcd18a70eb94bd3148363374b2697b03a62e0fefc4bba63a062c6a3d653"
  end

  depends_on "go" => :build
  depends_on "lima"

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -s -w
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

    generate_completions_from_executable(bin/"colima", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end

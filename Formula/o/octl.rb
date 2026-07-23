class Octl < Formula
  desc "Modern CLI for Outscale"
  homepage "https://github.com/outscale/octl"
  url "https://github.com/outscale/octl/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "3b7428a07d73785cd8eb9e633d349a9c215db50e848c72fbeacc38df76200bd0"
  license "BSD-3-Clause"
  head "https://github.com/outscale/octl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89fb0ce0e095a9d089813dfac941f32db975281c2346ebc0bc07e857b9482e51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e281b0fb5cba093b1a739473280a8ae9556440733ce5ef4f4f8ff415caf6642c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3350631a83d663731aa70d8bfe8ba84c4aab8260b1d73d3a6c0d83eb13e526b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f308c396923465f22e48dcc87e370d6f9b7ff7f2b38d3936c0c7481cd5ab240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fada54a38d7a84bea02a8f13dfd522c198c55a0d95638c399c98569b61f3fe9"
    sha256 cellar: :any,                 x86_64_linux:  "c5b87b4a74533d55da0de4cd2f2c122af2f8f25ac18d9dc24e55bd9ac5ea8924"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/outscale/octl/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "homebrew")

    generate_completions_from_executable(bin/"octl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octl --version")

    assert_match "One CLI to rule them all", shell_output("#{bin}/octl 2>&1")

    config = testpath/"config.json"
    system bin/"octl", "profile", "add", "brew-test",
           "--ak", "AKIADUMMY", "--sk", "SKDUMMY", "--region", "eu-west-2", "--config", config
    assert_match "eu-west-2", shell_output("#{bin}/octl profile list --config #{config}")
  end
end

class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://github.com/kool-dev/kool/archive/refs/tags/3.9.0.tar.gz"
  sha256 "af98db1eb6b7e90f528ae5802a059c563881de77477909a90f7bf9d2b47e70de"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d62e1a9905ea31f7d225809f47ec27d8c467a725324c21215b1bf2ff9252475"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d62e1a9905ea31f7d225809f47ec27d8c467a725324c21215b1bf2ff9252475"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d62e1a9905ea31f7d225809f47ec27d8c467a725324c21215b1bf2ff9252475"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de1fce509214aae1e972b70155252050b9e89bfe24c61fc1ad7536938650d2c2"
    sha256 cellar: :any,                 x86_64_linux:      "e9cb5afed0d628b2c2f071e04c3f8c9d6d9512a137ac88475d7680418151f95e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X kool-dev/kool/commands.version=#{version}")

    generate_completions_from_executable(bin/"kool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}/kool status 2>&1", 1)
  end
end

class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://github.com/kool-dev/kool/archive/refs/tags/3.8.1.tar.gz"
  sha256 "8b66c38fc4c03f09563f70badd5d52c961b6706152f760483099fa9a44caf64f"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35b580fa8a78e9d90fbf69ee768c851bbd5d89b9d402fd689976154db7552969"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35b580fa8a78e9d90fbf69ee768c851bbd5d89b9d402fd689976154db7552969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35b580fa8a78e9d90fbf69ee768c851bbd5d89b9d402fd689976154db7552969"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4781fd0829430e6c391d7e35a90753ed49444fc4d736658dd33aca73c9c2ac6a"
    sha256 cellar: :any,                 x86_64_linux:      "1a35827193369aca41e0c2541c6cc119031dc28ffc24d2224d91bbd743413904"
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

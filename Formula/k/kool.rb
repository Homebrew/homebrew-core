class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://github.com/kool-dev/kool/archive/refs/tags/3.6.0.tar.gz"
  sha256 "6fec7ef41259b69da8700ed4bb53ea4cf71ecb46634a64f42dc25ec4439dc126"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d91f2e9d8b46f95ee9782233b7e182434a5ac77cc84d21c8fc2d97dcdcf4f703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d91f2e9d8b46f95ee9782233b7e182434a5ac77cc84d21c8fc2d97dcdcf4f703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d91f2e9d8b46f95ee9782233b7e182434a5ac77cc84d21c8fc2d97dcdcf4f703"
    sha256 cellar: :any_skip_relocation, sonoma:        "31a23b93af595df38fa5e8b4da05f08cb28cd65fc45eb5258bd3586bfa867779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "449f0b84102e6b11f9a8a6b51f0e89e75ab0d96e9b2f92c2f48ef927f1290a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31693d6c71d67b9200013d12128632e0fd07550487bb427f4f6889b06416a6d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X kool-dev/kool/commands.version=#{version}")

    generate_completions_from_executable(bin/"kool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}/kool status 2>&1", 1)
  end
end

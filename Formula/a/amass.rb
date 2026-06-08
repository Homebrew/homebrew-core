class Amass < Formula
  desc "In-depth attack surface mapping and asset discovery"
  homepage "https://owasp.org/www-project-amass/"
  url "https://github.com/owasp-amass/amass/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "5aeb5fa23070fbd3aa365757e2bc9bd294f78456c4d391bc077769adbd1dbe0a"
  license "Apache-2.0"
  head "https://github.com/owasp-amass/amass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0858e9a8b7d99e76652642969d4ec85caea00169b6f55cff2793e2e0d50bd592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0858e9a8b7d99e76652642969d4ec85caea00169b6f55cff2793e2e0d50bd592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0858e9a8b7d99e76652642969d4ec85caea00169b6f55cff2793e2e0d50bd592"
    sha256 cellar: :any_skip_relocation, sonoma:        "4748b5419556f2afb8c22d9b58da675eab66a4320a5904ac0647f8161ab975c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd1da4421acfbfde4f85ebfc0bd338844d4b44d37db16855c2c6571a3cb5288a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8d71769197d1f6c9f503bd52306e26ab3484c64a5528f0c147416ee5d4bcb21"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/amass"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/amass --version 2>&1")

    (testpath/"config.yaml").write <<~YAML
      scope:
        domains:
          - example.com
    YAML

    system bin/"amass", "enum", "-list", "-config", testpath/"config.yaml"
  end
end

class Amass < Formula
  desc "In-depth attack surface mapping and asset discovery"
  homepage "https://owasp.org/www-project-amass/"
  url "https://github.com/owasp-amass/amass/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "9f2023027ed418e49ff0a7d941dae050db0f73b948fefe997aef416876cfb416"
  license "Apache-2.0"
  head "https://github.com/owasp-amass/amass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48f97158e2dfbaa19515ee25121d5544c50d78217e631761a51d96dcbcec8388"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48f97158e2dfbaa19515ee25121d5544c50d78217e631761a51d96dcbcec8388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48f97158e2dfbaa19515ee25121d5544c50d78217e631761a51d96dcbcec8388"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1aa38aaf84268c4f6a611738f2de94502c6a8359475e73660e6b007062bda12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ab4312afc237c520b92785e0c28136cf056eb0aaad1b8f6b143b9cf6e1459f6c"
  end

  depends_on "go" => :build

  # `test do` block performs DNS enumeration
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args, "./cmd/amass"
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

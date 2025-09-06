class Amass < Formula
  desc "In-depth attack surface mapping and asset discovery"
  homepage "https://owasp.org/www-project-amass/"
  url "https://github.com/owasp-amass/amass/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "975b23891423a29767d9d83c4d4d501e5ae524288be424b0052e61a9fe8a2869"
  license "Apache-2.0"
  head "https://github.com/owasp-amass/amass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02b740465d692f56dab68fb72af8a0ce33e23789b2c4767c0d3f99dd2498c74b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02b740465d692f56dab68fb72af8a0ce33e23789b2c4767c0d3f99dd2498c74b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02b740465d692f56dab68fb72af8a0ce33e23789b2c4767c0d3f99dd2498c74b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f61b7bb9b112737c54c6ff8b7386d992d10b181a874eb7fa67e3af439f82f86c"
    sha256 cellar: :any_skip_relocation, ventura:       "f61b7bb9b112737c54c6ff8b7386d992d10b181a874eb7fa67e3af439f82f86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12c8ade17915fd64c1e7ad5a84d366a4126bcc190ba69c8d2b0aa692f76b2a2"
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

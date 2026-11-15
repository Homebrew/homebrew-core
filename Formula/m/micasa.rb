class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/micasa-dev/micasa/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "147295292b73c6e94d1b4e139e54bf9b7f8dbee18932528c4f3959e6389a6cf4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3afb0919e7cb736e73bc0b0c40ca38d865a5fb771de0e068cdd50a10c67018f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3afb0919e7cb736e73bc0b0c40ca38d865a5fb771de0e068cdd50a10c67018f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3afb0919e7cb736e73bc0b0c40ca38d865a5fb771de0e068cdd50a10c67018f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45d153d07ca9d96ca2b8f88599b68af2f7ddab98b4c33d89dcdda0cdf3749afc"
    sha256 cellar: :any,                 x86_64_linux:      "8aa14c3b3cd9727d68eba4a0cce33297b34b20c6ec99012e07f2a5cea5145ac9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    system bin/"micasa", "demo", "--seed-only", testpath/"demo.db"
    assert_path_exists testpath/"demo.db"
  end
end

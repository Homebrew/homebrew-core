class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.114.tar.gz"
  sha256 "956fa49203c75fc255909473a2a7f9fdd4cd272e64a15628a692264e544bea04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58a42938e1f6dc985d906b6457d44b138f6ab4276ab738ebbd8818f0deee7e96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58a42938e1f6dc985d906b6457d44b138f6ab4276ab738ebbd8818f0deee7e96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58a42938e1f6dc985d906b6457d44b138f6ab4276ab738ebbd8818f0deee7e96"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "be3203eebcc3b11e17cf73793bf10d6cc429b40ee6d9ee4465cb0aa4cf784335"
    sha256 cellar: :any,                 x86_64_linux:      "1f084fffa30c144fbf3dd979779950bc48126918312fd5865e4e3aee26c6a8a8"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end

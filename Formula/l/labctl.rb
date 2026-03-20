class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.64.tar.gz"
  sha256 "22b281dd827c501228576a5b7acd4631d61c6ed5ccc3b3d0bb9d46ff6be1dc8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a8f34261b67bd25e1c36fad1c996ff8190c75f31902ee5a9b2f6e6de2898ec8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a8f34261b67bd25e1c36fad1c996ff8190c75f31902ee5a9b2f6e6de2898ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a8f34261b67bd25e1c36fad1c996ff8190c75f31902ee5a9b2f6e6de2898ec8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b8fc14e29fd6bf614dcc41418e9b34a9ae4428c34267525351016097ee6300e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f28136443252fdec364f43422348f76c11810ac4bca0bfa29252817f6e53035f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "959c12a0de0043f43a4bdfe03f680a9cd357ea65fc4930d1ab595864611d4d74"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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

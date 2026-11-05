class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "69da3a5e71f3f3c0ef0bb5951b5bf0f7a2c662b5578a0a58e96a26122d48dfd9"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1279fb4f7dc90a1d1520121326f41dc103d17536ae6f6515c32f4732b2bbaa1f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1279fb4f7dc90a1d1520121326f41dc103d17536ae6f6515c32f4732b2bbaa1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1279fb4f7dc90a1d1520121326f41dc103d17536ae6f6515c32f4732b2bbaa1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "501b49229cc9228f6d1172fb514cd44586a65e75e19de4e64a4d0972be711704"
    sha256 cellar: :any,                 x86_64_linux:      "3e5bf4c39b676a88f0e27d89b00036b04daaa60ca3debc696e94fd775cf8ae29"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end

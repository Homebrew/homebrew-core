class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "d347a81eb6b6e074b394116faf088ec272e817a6ab3dd415ad9956dba1758ec2"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06f2ac4aa03bf9a18336459ee478600d2ff83a19cc86614be0630b1b2a2ac90a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06f2ac4aa03bf9a18336459ee478600d2ff83a19cc86614be0630b1b2a2ac90a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06f2ac4aa03bf9a18336459ee478600d2ff83a19cc86614be0630b1b2a2ac90a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "06f2ac4aa03bf9a18336459ee478600d2ff83a19cc86614be0630b1b2a2ac90a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afa4b97ecd70bb87c4195d0b2fffbe4a21ce3614e7c5ddb7b3b8a034b8cd86ad"
    sha256 cellar: :any,                 x86_64_linux:      "d8235b39f2310d9876ded4701f82922c16fcc3a097e0f71946486599ce09746b"
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

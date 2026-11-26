class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.18.tar.gz"
  sha256 "41c3af732258df9b8e5f786c4c73dfc0a9c5b16911904ae6d5800454da7eb36b"
  license "MIT"
  head "https://github.com/descope/descopecli.git", branch: "main"

  bottle do
    manifest_sha256 "7460814c54cc9822d8273b82b92b13c26c57e207605ab60bf848b0ade94a5562"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f8e8d3c8de056d516d56457e0d58caafcb1885694bd954f4a74e59eebf25e54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f8e8d3c8de056d516d56457e0d58caafcb1885694bd954f4a74e59eebf25e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f8e8d3c8de056d516d56457e0d58caafcb1885694bd954f4a74e59eebf25e54"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e74a10375f75c74d40001400b6ac14e9ffd1a7e418660ba45c63e57682e530ec"
    sha256 cellar: :any,                 x86_64_linux:      "687868cdbad6670e506e4f0e027105ddfc0bdd550a6eb3baa064329b7dc57c79"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"descope", shell_parameter_format: :cobra)
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}/descope audit")
    assert_match "managing projects", shell_output("#{bin}/descope project")
    assert_match version.to_s, shell_output("#{bin}/descope --version")
  end
end

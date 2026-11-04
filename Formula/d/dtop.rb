class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "40914b0d87c8cab2a4f2e22bdc14c5df1f6731f2014e51b9c61ad95990280cc0"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45a416437181bfe0c89649fa2cde937f6f1addcfc4532593a5ad85ff02537767"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e24c0784f13f1a6f26ed7024f4cd4ed9e23bb24cc8e83936317c4cb37f487227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6889a6c4c82b297d4d1a9d4b764a9fa62d4667aa149b82831010e354436cf5e"
    sha256 cellar: :any,                 arm64_linux:       "3f49fab70354ad1bafbfa6caf8283103f51942b07a7ca9c64a795fa295edacf7"
    sha256 cellar: :any,                 x86_64_linux:      "97fe183d9594db6e4d2421304d18e4314fcf9e8b4079929cd45e65e0fe74080d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end

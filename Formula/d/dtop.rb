class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "40914b0d87c8cab2a4f2e22bdc14c5df1f6731f2014e51b9c61ad95990280cc0"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdd867327bb08c5317e229c3fdc0ec334013bf42b3fd0d488fcae07a1a286bb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a3fb1edb7feab85625bd5f0e5104724a6fde8faa6666d9282a2e4d624d9f30a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3fe1d062a751b3c26a6e13899df76ec97418b5c576383d4a06865a508cf5d664"
    sha256 cellar: :any,                 arm64_linux:       "09d89699fa13e6cd14c684ef23c07298b1a7f2ab307cc013b3f8629a18be1cbb"
    sha256 cellar: :any,                 x86_64_linux:      "953f6dab99b45653ecda4b79e61619248709fbcd95fc3a401cce80b7249276af"
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

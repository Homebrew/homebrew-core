class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "0b1ba4322845cf23b5095bb2392864b49db10e48abba60982db894807b4bbb62"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1ae1256468f90de0c001c39075f159ff9d94d63ed208f5009e5c0a02005bbb1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d468dd738e8882339f9f9e7056a3639b77ef50fd07d9b38eca416256f17491a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b4677b766ad49aa9bc9045962916960b6388d339a2d60345e531cb266d69050"
    sha256 cellar: :any,                 arm64_linux:       "90d5d7e033207b61e49988f74027817dfdc1323ba8a5c5cac8343bcd825c69db"
    sha256 cellar: :any,                 x86_64_linux:      "d0340299264cf17b5536ffb6b1b8cdbd0837e4d6a23c51fa1902a00d8e1aff8d"
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

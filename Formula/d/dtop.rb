class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "5594a10a5ef41431309e6d15a44c0d44aae209bdee9782be30acf77d66923b42"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2d693500d515ea0671875151b15285394b0b98a1982c2fd21d87627320afd71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7861e0e0be39ad0c7e7dc858c97a3c0228722bc6e00c62809dc11e509c8d0cc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b1e3c05cd7b28078b80450cc4f82747e41422a928f3042f46fdb5e43f1974e6"
    sha256 cellar: :any,                 arm64_linux:       "ed2921f002e95783281c5e403f39e1d0e8289ed61c0fc8bb603ee48634eed186"
    sha256 cellar: :any,                 x86_64_linux:      "67ecb9bc10bb258819bbd82d0ab03dd0ed2c33df891206d9215e04151e79c1b8"
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

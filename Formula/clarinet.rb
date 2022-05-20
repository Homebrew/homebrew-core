class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.30.0",
      revision: "79f8a4f94e3941193d96c3416b2c6e916a62f1d3"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0977709e02ad7a97c0a3228cead4adf25f6cd95bc8e38235c60b2109a885311"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce27886590d29994fb06419a628c7980c8435f4352d33db78c80d3074a88adf0"
    sha256 cellar: :any_skip_relocation, monterey:       "a1872f7a8ad3e2d015530eca089d484eae18c911b472ded67ace1269356f322b"
    sha256 cellar: :any_skip_relocation, big_sur:        "13a2098559e3c253eef3ece51b4fb8b3bf696d085d86daec8cbab4eacdab149c"
    sha256 cellar: :any_skip_relocation, catalina:       "10ee4264bd40b7d9b16eed0209148941a1197d2d212d5abbc7b6592d332f0000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c7fefadff7a73141be308d977107ccbc8992e27cec7d878e6f564f6b8fd448"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end

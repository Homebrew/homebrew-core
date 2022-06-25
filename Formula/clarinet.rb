class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.32.0",
      revision: "30fa422f58f108e2e13e10e893117706d4cc1c1a"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "094a207e5571c3a39d6a80267398fb6ae7719ea97e1d228ffa9ed43c9197c2a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab1a4baf12319cecf13776ed3ebdcfdc5af8de7c9697e401ef3a33412e3ead8d"
    sha256 cellar: :any_skip_relocation, monterey:       "225c016dbafbead9d6a58affc2f0305eb246edbf0389f3e20b2116b05a9ede38"
    sha256 cellar: :any_skip_relocation, big_sur:        "41d0e8ea2d22fe9a01ae1306537704fe3768af2b7578a1d42ecec1d7cd4a4846"
    sha256 cellar: :any_skip_relocation, catalina:       "019083d22ae921aa7afdee6b47855059512d82c05f52af81787302d44a1060e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42fd543f0b5bad329c4a73a4a61e7d0ed980125990976bc60dcf04560decafd7"
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

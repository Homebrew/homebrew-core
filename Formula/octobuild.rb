class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/0.6.0.tar.gz"
  sha256 "df1704a2758a1f5d8db0c00b02076b2e2fc843caed9dfa9b6d055c28cfd51b4c"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90a3c5f36eecd49278f81f56b7f08ee1f26f418bc74a9361daff0a543a877a14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cc1ba2bd69c6881bf0b7ddec17b06bdecdd1e0d4ad534a01a03a1aee49e2b3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a883cc0d682ef6c9e4a447ca3ff08438feb4947809ee196c725b2407d1be7df"
    sha256 cellar: :any_skip_relocation, ventura:        "311c925fad00b188331f560a15171fcc1c1249a064e65745d3b775317c56508b"
    sha256 cellar: :any_skip_relocation, monterey:       "bd75856037043b554272aa4fd4d402884fdcec82f525bb375e96ab9721b7e131"
    sha256 cellar: :any_skip_relocation, big_sur:        "f73be32ecf6830d72a2b4258cfff3c62829604ca9eaaaafb4970b5789e75d20a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c444eeb7b3c013cf7c8b977595c5d5a37aa3ad4c9cb5589651050b2c9d3f59"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end

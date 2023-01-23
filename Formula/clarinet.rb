class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.4.0",
      revision: "b02d2d01b920bd828175ffdf55b7bcf7f0668335"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acf50564ba1c3b5e95c5145d08f75b684dac5ac0b9ecb6a821f64beb94ec31a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceca26f0c89a13f9868e154cd9a035a10d2f288320b074906899117d8681db39"
    sha256 cellar: :any_skip_relocation, ventura:        "c76814f6ef76dfa767fa1c877d9f5d16c0326bc3a920f5ba2d661bdc606bdcf4"
    sha256 cellar: :any_skip_relocation, monterey:       "e88f81de5b4144d310d49f005443ac6ea9664b7047649760ba4c5ad479f5a5d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f162aa89b9773026aafb82696cace73bd6a1ed04fb20a3a1f00633d0058bd9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83fcb2d9aea7a05407b3c68be10206d4e1164c9bed3135080853ee7c935292e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end

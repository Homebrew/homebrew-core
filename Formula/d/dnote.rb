class Dnote < Formula
  desc "Simple command-line notebook"
  homepage "https://www.getdnote.com"
  url "https://github.com/dnote/dnote/archive/refs/tags/cli-v0.18.0.tar.gz"
  sha256 "0d57c088448704fe98c58a8a9aa12e308885661e497c0400ad43d367c556ccf1"
  license "Apache-2.0"
  head "https://github.com/dnote/dnote.git", branch: "master"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "4d7e76d8ca15882c7b60d80dbd13874e9b28437c3b89a09ccb85d4406ea70ff8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55e8e4e406b2bd714718a2dad07c17c7905eab5bb8fd1919476bd82c1e8f64eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c01c66cbd20df34fb11c2218e354739ac5b7c8bf604ad2f912b1bdd0d54d1df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d35446509a6ad0b4fc59bf74e5bc98ce52447e7c232d7b166c3bc44f754a498f"
    sha256 cellar: :any,                 arm64_linux:       "ef0fe75fd1d133942668505c4cd64c802b2b45c6b8dfab63c6275af508c38d23"
    sha256 cellar: :any,                 x86_64_linux:      "2067229c0323e07c133dd84a9b21d9d01fea3c7958b3985d8ddfa120dd85b882"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-X main.versionTag=#{version} -X main.apiEndpoint=http://localhost:3001/api"
    system "go", "build", *std_go_args(ldflags:, tags: "fts5"), "./pkg/cli"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/dnote version")

    desc = "Check disk usage with df -h"
    system bin/"dnote", "add", "linux", "-c", desc
    assert_match desc, shell_output("#{bin}/dnote view linux")
    assert_match desc, shell_output("#{bin}/dnote find 'disk usage'")
  end
end

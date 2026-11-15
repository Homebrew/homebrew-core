class Dnote < Formula
  desc "Simple command-line notebook"
  homepage "https://www.getdnote.com"
  url "https://github.com/dnote/dnote/archive/refs/tags/cli-v0.17.0.tar.gz"
  sha256 "29a15bc4e397a1c02117adc1e5a35ff8f6bd35d50cb36f570144a3d10c2ed0bc"
  license "Apache-2.0"
  head "https://github.com/dnote/dnote.git", branch: "master"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c0f624aa1d2dc38208be0ae287a76e0c2e8fa6d688068ad31d1375499c27d41"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21fa4192d6a2339847043dd0594643ba4463cfc15a543e19c4bac6d425833370"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0edb2943f3e6812fe0d59141ce3dd403638e89436d4cffec7fc6d1f0f6eb3762"
    sha256 cellar: :any,                 arm64_linux:       "271061a746c03a40565e4c9082b3a411c21ecfbe779ac775b3dfe80df2cb8374"
    sha256 cellar: :any,                 x86_64_linux:      "60be9af2505c5c1073535d141ff5005a263e01e7a788858d769093a782ca0a8d"
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

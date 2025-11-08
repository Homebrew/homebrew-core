class Dnote < Formula
  desc "Simple command-line notebook"
  homepage "https://www.getdnote.com"
  url "https://github.com/dnote/dnote/archive/refs/tags/cli-v0.15.5.tar.gz"
  sha256 "923e959d32885f01e426e37e7240bf9a66addbdfd95620846fa535e4b7f7d2e4"
  license "GPL-3.0-only"
  head "https://github.com/dnote/dnote.git", branch: "master"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d1f9861be49752fdd4cc12e1f224a293b7cfafadbcb68fc83d56e05d3c31d0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60fcee308d5b2b28360906f0fe521a9cfefc65ca1330e2609864196b7ebd2bcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ce8f4168857e20b7d1420ce634f41c22a3c3920c2b79562a6292019e050ff6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "35bcefd91e7cb410295ff6a2c7620e0e139dd6dc826d284e7bf7edeb36922890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a8e4f4ff67602a4ff1af0178b99aef9bea54b38f6afbf89d10310ed4dfc3931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a293df56230be458f2c7131841f37a352d0b234d62f4929f47a9085e76df8660"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.versionTag=#{version} -X main.apiEndpoint=http://localhost:3001/api"
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

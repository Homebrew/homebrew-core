class Dnote < Formula
  desc "Simple command-line notebook"
  homepage "https://www.getdnote.com"
  url "https://github.com/dnote/dnote/archive/refs/tags/cli-v0.16.0.tar.gz"
  sha256 "fb63c6099ca441a2027a9e8ae2a3c38376e5c0950bef9e8028b96ca2b8b6427f"
  license "Apache-2.0"
  head "https://github.com/dnote/dnote.git", branch: "master"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f637f4ab476f78b3958461227122f698b0f11f7ea63b24db9e58c3c766b075e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883b47fc6eb59dc29cf6bdda3fd5733da9268dd3b5bef0d8a3dd39b3a6fe2be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46f67f0f6bed3576a601c8de799a14c46a239b43971ddac113fab02fc3f05b88"
    sha256 cellar: :any_skip_relocation, sonoma:        "55ef785d358763e6266ad5d5d806cd7bd115b25841b5d161537881babc60f91b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f11ba266b712e74a4a06caccd74592e975eba3e8157e88ed64bd0e228ade1e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51a5368322863db842812dde4cd9ddc1db22feecf5fc7c937012c40155c28dd"
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

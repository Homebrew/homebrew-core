class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.32.4.tar.gz"
  sha256 "0c2fff735afdf7ddf2750b453ec457514b74a036963542a6b9dc4a0ab08bf46b"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6e54a7572448c9d7d507555e8b2312e45a00e8c96da4845cf490b738b6eecc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c674b2cf87389631907393fa036a76d72d0c3f13d4d698c5da9a108fe22862"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fb1cc7d16b1194f7b05234d631ad8a36eeac0e22c76286f835b925a3a86f136"
    sha256 cellar: :any_skip_relocation, ventura:        "b874a6bcf8869f1d71cf45a836f19b50bb55647f51882d9ff69ea75491eb801f"
    sha256 cellar: :any_skip_relocation, monterey:       "0c80e855e7ba051f262a3cbf265ed530efde3a2f0c572bef79e4366cef85fd3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae2b805b832e29448696f3420280e671280fe3e3186e3e0d892a29f40761fbd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8496cb3f3a407c5a31a73a7eb76f6f5df9936f7f38d505c3eabda793262284"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end

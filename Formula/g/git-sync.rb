class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "0961f09e3c370f68bd10d6de4c44673ddd7b4adc602d38a7e67d22ae7fe6ae2e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f519dd5d3f4e17d08cd18df54321f4b1927dbf5b8796414817bbfb4bb957e623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f519dd5d3f4e17d08cd18df54321f4b1927dbf5b8796414817bbfb4bb957e623"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f519dd5d3f4e17d08cd18df54321f4b1927dbf5b8796414817bbfb4bb957e623"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba49e1392eac821ae7281be0ed6ac349846aad756c9c6d411f4d9401cea094bf"
    sha256 cellar: :any_skip_relocation, ventura:       "ba49e1392eac821ae7281be0ed6ac349846aad756c9c6d411f4d9401cea094bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4586a92451531c814868c94f92e2d5097f9171036d60e70769005b3dceee3ca5"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.io/git-sync/pkg/version.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end

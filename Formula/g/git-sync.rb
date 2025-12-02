class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "4f6ed2d3c4be008104f0fd8a05174b4a6652944d6ee050021b1ecab9b31d1c45"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1bd643552fe6a64a201af7955452afc6fc6c72a95f631e179baf9ce40f51beb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1bd643552fe6a64a201af7955452afc6fc6c72a95f631e179baf9ce40f51beb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1bd643552fe6a64a201af7955452afc6fc6c72a95f631e179baf9ce40f51beb"
    sha256 cellar: :any_skip_relocation, sonoma:        "174a2da0660a78d23190fb51f217875b9a9396f51471794f67eaf97165019ac7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2817fd83194a339ab7fcad1f3aed0f2bbfd71b382e25ab9e24396bc9d2a27f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd57ac983a4b71fa0d354c18671dbd5fc13dea79db3ba3ea23ae35779dd13668"
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

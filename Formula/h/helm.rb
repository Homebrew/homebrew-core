class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.13.3",
      revision: "c8b948945e52abba22ff885446a1486cb5fd3474"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a6fd49305a1d9aa469785bb6d02cdbaf618a31db1752ccfce5015ce3fd2740b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "883818f3e20b01fc8a779fc26e8e42f5ff43ddb965e8ab23eab70cc82d95a667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06bce9cc4e0b7f2de37b17248316b64be9e094bacc1b794007873dfdb306cbfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "fea0d69036152c08eb2ef8e2a9b35cb2e94cd47ec4d2eafa611c4f51d97fc23b"
    sha256 cellar: :any_skip_relocation, ventura:        "eda830769fad1bd367c6c02c27888a375b8b53a638a9ad2c42a83a72a55a4bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "20543f3f9741baebd58e07bc37cd776b77ad468bce93087fac3b25befa311efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea2c821b0f30172519d5dc78993eb9018d9ac9149c0fa5d973121f157f9102de"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", "completion")
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output(bin/"helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end

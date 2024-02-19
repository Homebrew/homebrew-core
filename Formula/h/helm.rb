class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.14.1",
      revision: "e8858f8696b144ee7c533bd9d49a353ee6c4b98d"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db9203deb4e0836c6bec566017cbbc225ecc62b7925217aca49f784f38cb30b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81522c395cee87e80b24dea02c5968c05a54939a846a89dbdbbb2fceea53797a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d346ba8be0b6d70aaf61dee99bcc6e8f7b384f7eb936f059ccc1d1e68df0f73c"
    sha256 cellar: :any_skip_relocation, sonoma:         "68ff72edb2329cecc800dd93f72998b53999cf94953a1ec5f8a26f5c9e630490"
    sha256 cellar: :any_skip_relocation, ventura:        "dc594e585fafae33f4ed5b05756b755ee496876e4eb3608f8482b86d8865dcf9"
    sha256 cellar: :any_skip_relocation, monterey:       "f2f2e7b9555ec5c33fec394c54efaba084ccee1611f81e21e22d69a38bb09ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e70555fce39c649316a48579ae5cbbd80aee3dc0e6e51c9b279f787d08ac62e"
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

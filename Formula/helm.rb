class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.11.2",
      revision: "912ebc1cd10d38d340f048efaf0abda047c3468e"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91a10cc1cff1117e2a8a716cc25ee2bf3ea290315c9f5f3673e642e173b0e632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d16449946581202390faa50fe5048e4e79424208b07379fddfd68b92990d5f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "134d9cc8145fcd808d8e7eafa4cd3bbbe80ab197cbf7f4ff811b2645b4d7a407"
    sha256 cellar: :any_skip_relocation, ventura:        "2a84b6e28561d32722f4bc31808ac21b00c7292d5dd95c119bad4c202867c415"
    sha256 cellar: :any_skip_relocation, monterey:       "52b09323aff9fae324c752b1a44e498ea85de1303823264586d59c2b9c4a3fd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "676e53a447c8dd2e55c0217fb65015f88a1b9a7f165359b5e36d08fd589e1bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcea57393287b3e60df1f4635a01707de030a543bcaa94f604c3adfaa87065f1"
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

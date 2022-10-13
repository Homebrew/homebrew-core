class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.10.1",
      revision: "9f88ccb6aee40b9a0535fcc7efea6055e1ef72c9"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "284e4c49deee49ccec75835fa7e3173cbc9045db1b70a35d4511a9e993339cfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c65b7a2ce00ae6aeb1a635445b7b63b57dd0ec85719d303198469094c4ee6d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "09afc8d94008a2b6992739525c590d7e091b78f96593ec8af0196588165cd7c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3010ff191d753526db401e89724e9d60921e168735e4ca3e8e879b51e210c7b1"
    sha256 cellar: :any_skip_relocation, catalina:       "bbabcdf0470dbbbfd824a4e7530cdbb332ec01b82e53d78a8349007d8e1844dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7675ca97ae59e3c45ed15ee3700ae6d8c6a9a24bb4c2b165fca8274a466f794"
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

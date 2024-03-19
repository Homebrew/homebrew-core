class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.14.3",
      revision: "f03cc04caaa8f6d7c3e67cf918929150cf6f3f12"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "124b261445e83d44dd036c85963c31411e44dec3358b6c1e181cd693f3c32121"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bcb4f2721ef8f80a1a3e9ea11cd087309d3a079e33322fc893bf1987922931e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88f67fb12e9f9d1bdc49ca4b48677b1a0d281d986983a1b737cde2fcbb92e7be"
    sha256 cellar: :any_skip_relocation, sonoma:         "49025e7d5bbffa8268fe392068fd64d17f40523820d7eb01a1f17ceaa21abf66"
    sha256 cellar: :any_skip_relocation, ventura:        "d4713973512f2a2e6477be9a7042781c31fb88e5fceb58a58965dd0aa554f371"
    sha256 cellar: :any_skip_relocation, monterey:       "6be0e7b74e1789234324b0bf69b814da13fbcbc140faa6c9d14206a203509727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2188c81963da82df4dc98d28f9cfffb9b785d298813caa9507badcc3dda15217"
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

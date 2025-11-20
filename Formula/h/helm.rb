class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v4.0.0",
      revision: "99cd1964357c793351be481d55abbe21c6b2f4ec"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "801f5e2e1471427aee9e2c6fe3618759de1caf4178838c68d5b0bdb9fea521e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69d24be9e621254805bce9fd3100e17b88bbcd7ff6637a323f92d99bf3ff5128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfc9786b9e32abd0130b67a8d0ea496b9aad516f260b5d23caaa5a32e0706a30"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a20b815d0952f0df2b9b5d22728016e14d9ff8105656201d621bc224ad13f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96687c6d0c645d5bcaac695a616cbf44d4d9e6da394cc8161ee0323fadf75acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee5b941c9bb1954b503ab2531eb35851f03e12a765c1f20fae199633610e111"
  end

  depends_on "go" => :build

  def install
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

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end

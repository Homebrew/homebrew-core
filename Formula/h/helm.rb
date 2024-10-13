class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.16.2",
      revision: "13654a52f7c70a143b1dd51416d633e1071faffb"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ad3314a8d2eda0a9fdc822adb7117107cb1df214012245370e3756918222ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca9adda46f918e7b6c33349ce871a65c3a82f308539ab910396c802d3dfd08da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bcf7612097cf01e16695a53bf33ff8794e4de114847c14e7bebdd430ed249f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "41256c21b0ea9ecea53c31675ef0dc2e683f83feafd664a8bb6e170fbc705645"
    sha256 cellar: :any_skip_relocation, ventura:       "575f55d49da92c7679c285bdc17056b5df25ea277f74e951e35024da0c7c019d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d13febc5a4916a8f8c7c9918365c27fd862279c5c540ee7d4896b4ebd142402e"
  end

  depends_on "go" => :build

  # fix testchart lint errors, upstream pr ref, https://github.com/helm/helm/pull/13329
  patch do
    url "https://github.com/helm/helm/commit/ddead08eb8e7e3fbbdbb6d40938dda36905789af.patch?full_index=1"
    sha256 "471c2d7dcbd48d37eaf69e552d53e928e9ba42efccb021d78bbd354599d80811"
  end

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

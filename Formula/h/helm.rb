class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.14.4",
      revision: "81c902a123462fd4052bc5e9aa9c513c4c8fc142"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e26a9f7289dd32daf55b078e158f736d0c4e489ad75ccfb51ace3d2fca78b788"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8a2de09888e8b6eebfee775fd970032fea3168b80c3b68dd8caa2f89f890d56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e175f39b3411666b1888cde07eba48d0e31e897c65424034486268079a2b988e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c4310617e2e848a2219a32783cfbdcc08390cb925c1de5f102c601cf208495a"
    sha256 cellar: :any_skip_relocation, ventura:        "7368c508c67896b563d7e9f9648f45bbebc39422ad9e8061dbfb803442bfc4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "223c21a96777beebc645d95e7278112621af3adf703d9a06b77ce27b235aa24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c03f09028320d3478f54f94d1467a24de06cdd6caf9a88760f4ed14f5e59b3a"
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

    version_output = shell_output(bin/"helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end

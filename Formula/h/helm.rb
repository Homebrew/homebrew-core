class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.14.3",
      revision: "f03cc04caaa8f6d7c3e67cf918929150cf6f3f12"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3b79330ba32f7e7da271be6d99a3b9685a8e9283be86116577a138150c95f4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4874bbf7bc5edb5f7f55b4a180861f420bc659255201f7aa92a1b3af0dd2853e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72b46377131d5998420cd5f5dffbd5de5884335090a08bcd5f7ebea50ff8a11c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1742ddf278457ca290e9723c5fdda808ed3181cf541a179507de019d3f1f6a02"
    sha256 cellar: :any_skip_relocation, ventura:        "53f1412e756f7fcbbb07fe900bd4be42776a524c78f5e172adffd1d4ef6ba55e"
    sha256 cellar: :any_skip_relocation, monterey:       "dff1b96633735c90d08b55295bddc375389a57eda2c49a6c85856a8f0fd2a2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced53a4e11293b6c1084aff7d20bcf19f084e19728f5d3c5f5beb82e4eb6bff3"
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

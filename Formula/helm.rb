class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.12.1",
      revision: "f32a527a060157990e2aa86bf45010dfb3cc8b8d"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c5dd04eec038ddb1941a568d157ef7c8a22d6482a905fed7d88337d858d886a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "724adb3b35d6a6731541ec4b33f06a7236f7ef0117978576cf0336a6c855ecf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3dc92276e8de7df2d492e47dc268cfce1716ba8e3cab5e40811401287c309f4"
    sha256 cellar: :any_skip_relocation, ventura:        "af9b21bd1de386db05f17351dabec34763e6c5ae66384a95e0d92fdae41d9e73"
    sha256 cellar: :any_skip_relocation, monterey:       "f90ae30be524d71e0cc8dd4ee91300266cd5601911b718ec9109b8f66cc93a13"
    sha256 cellar: :any_skip_relocation, big_sur:        "67481b9c2415243562058b5e548139f2381ed577092dbbc3fff2965baaa4920b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f830f57cb29cf53274f524be78f4291e64dd5d1c319aa1099e8009e0931afd"
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

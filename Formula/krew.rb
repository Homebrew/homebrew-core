class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      tag:      "v0.4.1",
      revision: "ffa2933fba45e5577a45a944da1c14a1058d4fcb"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/krew.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93bec04317c26ad77d8351150a7d7f6775218e3149bae190ac58db96ed83b3bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "72ec667db2da34fc298d32f376ae8a8a5769858a418185c5b581bec29458e394"
    sha256 cellar: :any_skip_relocation, catalina:      "59131bf3f0e3264dd96a4f788cbe44bef4d4c21056dc583d912c3788cd429670"
    sha256 cellar: :any_skip_relocation, mojave:        "677db3b345035e81dbd8ae57ef4c27e3693dcc0fafd279a508f20485a59d005c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a57b4ff8bc90137b981cbd5baeccfc88573dca08a335e4af822c7a22079264"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    # build in local dir to avoid this error:
    # go build: cannot write multiple packages to non-directory /usr/local/Cellar/krew/0.3.2/bin/krew
    mkdir "build"

    ldflags = %W[
      -w
      -X sigs.k8s.io/krew/internal/version.gitCommit=#{Utils.git_short_head(length: 8)}
      -X sigs.k8s.io/krew/internal/version.gitTag=v#{version}
    ]

    system "go", "build", "-o", "build", "-tags", "netgo",
      "-ldflags", ldflags.join(" "), "./cmd/krew"
    # install as kubectl-krew for kubectl to find as plugin
    bin.install "build/krew" => "kubectl-krew"
  end

  test do
    ENV["KREW_ROOT"] = testpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{testpath}/bin"
    system "#{bin}/kubectl-krew", "version"
    system "#{bin}/kubectl-krew", "update"
    system "#{bin}/kubectl-krew", "install", "ctx"
    assert_match "v#{version}", shell_output("#{bin}/kubectl-krew version")
    assert_predicate testpath/"bin/kubectl-ctx", :exist?
  end
end

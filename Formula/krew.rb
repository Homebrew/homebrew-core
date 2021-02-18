class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      tag:      "v0.4.1",
      revision: "ffa2933fba45e5577a45a944da1c14a1058d4fcb"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/krew.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "6c2551cb0590797ea25e065d28d6c49e0c30fdf38e09f68093d9c65d66669079"
    sha256 cellar: :any_skip_relocation, catalina: "cd3da7ea5cfb37a67d86b5c2777c5e07b99a9c8d93a64a370c69e1138313c60d"
    sha256 cellar: :any_skip_relocation, mojave:   "e0b871ee1e6d5b93113f5a27cc7a09afed17134ad873e3b664be544503aa9108"
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

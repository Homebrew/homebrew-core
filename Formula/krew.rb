class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      tag:      "v0.4.3",
      revision: "dbfefa58e3087bdd8eb1985a28f7caa7427c4e4d"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/krew.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "151b1c29e53966fffef47ccd89deade4baba05996ddb128c3618882ce3a69895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93179328dd5beac3e977ab799d596925d927efa4420a6cb0950970386e4e8146"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9585376236e8f86e158864ff610edeca3eb83ad5566fa4a2a09f3fc35d6fe88"
    sha256 cellar: :any_skip_relocation, ventura:        "62c5d14ea93f6d3734d5e399cfce8511f24f4e0fc4c7cf6f7079aa17849265fb"
    sha256 cellar: :any_skip_relocation, monterey:       "d814754adf0a451c529a745b5ddc6587c0057d8050294610f396f97271e23e42"
    sha256 cellar: :any_skip_relocation, big_sur:        "286bae73781b3ced48cb18133afc6c3224dd15fef262dee1e17a53a8bed2dd6f"
    sha256 cellar: :any_skip_relocation, catalina:       "9c95c5f27125a2edcd294310c83d01c5ecbe0e1bb456fa3cc57ba6a632987278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dbbeefb32e6340c061091a744b4d5e4c7573e96a3512b27064349f286a1976e"
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

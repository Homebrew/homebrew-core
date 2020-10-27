class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      tag:      "v0.4.0",
      revision: "8bebb56d7295f361db3780fa18bd9f2f995ed48f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d9829908a9d668fc86eb86a675201202d42091ab93931b25f6b0f6f097191a1" => :catalina
    sha256 "c4e11ef97fc169636f581737325617cc64e672c995c916bd6fb6a49d90268ab9" => :mojave
    sha256 "cd01a286df37159eec08266e02ab5637fcb953418ec5c220c4718f73bac43d5d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short=8", "HEAD").chomp
    ENV["CGO_ENABLED"] = "0"
    # build in local dir to avoid this error:
    # go build: cannot write multiple packages to non-directory /usr/local/Cellar/krew/0.3.2/bin/krew
    mkdir "build"

    ldflags = %W[
      -w
      -X sigs.k8s.io/krew/pkg/version.gitCommit=#{commit}
      -X sigs.k8s.io/krew/pkg/version.gitTag=v#{version}
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
    assert_predicate testpath/"bin/kubectl-ctx", :exist?
  end
end

class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      :tag      => "v0.3.4",
      :revision => "324f5ed8fa7c2469ed6cd5a3dadbcbc0ce1d8b97"
  sha256 "d63e0ccc08f32bfc314b3bc574f20842041e2f58ab89ddc88a24cb25c1caee38"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "02f59277639b23de8638d475eb541a825fd0ed3f13abcd451598f012266a9ec7" => :catalina
    sha256 "cea370c93a43aa395003cf87430460746c29504c6b9bd8d8545ff9db31fa3fcf" => :mojave
    sha256 "69856b8926a34eac58aee438f52638553fda02d6ccbde22a09fbc2bded4b2cc1" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    commit = Utils.popen_read("git", "rev-parse", "--short=8", "HEAD").chomp
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

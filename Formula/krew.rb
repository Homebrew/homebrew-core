class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      :tag      => "v0.3.3",
      :revision => "71418fab437b55a740118ed9fac43fe79be98549"
  sha256 "d63e0ccc08f32bfc314b3bc574f20842041e2f58ab89ddc88a24cb25c1caee38"

  bottle do
    cellar :any_skip_relocation
    sha256 "49372e20f44396c3e59fbe23d38c57666c16ceb2eb0944cf2db86f8e338d36be" => :catalina
    sha256 "be7a0ce7b5a7c7912b43372fe17e7875e360eff33c906864190e04d816a1b5a8" => :mojave
    sha256 "afc98259de2d35aa3cfb633b0e4bcb63b050f6a11179857439950e241e69cb40" => :high_sierra
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

class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      tag:      "v0.4.0",
      revision: "8bebb56d7295f361db3780fa18bd9f2f995ed48f"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/krew.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "805ecc421849656067f79bb29078044ef16f4e7666bb3733754efddd5d541849" => :big_sur
    sha256 "ab1fd5afe499a31d731cc9b4395d3ae71eb4774682b5295e8376611c52f8a262" => :catalina
    sha256 "316b12ecb167df6a8cff3521d9ab093f874f1d49379ffd639a0bc1c77a9c8e01" => :mojave
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
      -X sigs.k8s.io/krew/pkg/version.gitCommit=#{Utils.git_short_head(length: 8)}
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

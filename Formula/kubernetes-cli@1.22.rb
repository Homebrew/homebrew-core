class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.15",
      revision: "1d79bc3bcccfba7466c44cc2055d6e7442e140ea"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "433f8586e8f0369a90fcd86cbd3d72ac37a3be9211bed34cd189437dde41a9b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc7a02932c1f23a0f12ab5fb1b518bee4f58388181d5f4d04c6b63fa39c64472"
    sha256 cellar: :any_skip_relocation, monterey:       "65d5359e50371e8e8744cedc43188cd8e7653f30ef1c61d1a7e091450641abcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "746022f84e82ee577dbb6ac5f9809b8001c978d234ffaced26e8ddb3e9fdefd8"
    sha256 cellar: :any_skip_relocation, catalina:       "3de9db918991c964b7e98d5739fc55460c400fd9f3883e3c75a99ba7ff0fb980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "069ea3adde7113771abb722a17594eddfb068deb30592ebcd83d51d1cbc08564"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-22
  deprecate! date: "2022-08-28", because: :deprecated_upstream
  # disable! date: "2022-10-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.16" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    # Make binary
    # Deparallelize to avoid race conditions in creating symlinks, creating an error like:
    #   ln: failed to create symbolic link: File exists
    # See https://github.com/kubernetes/kubernetes/issues/106165
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl", shells: [:bash, :zsh])

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end

class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.30.5",
      revision: "74e84a90c725047b1328ff3d589fedb1cb7a120e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.30(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa7b56c1d3098bd993b7d7db1bf071e2155e2dccc74ada4680adfe5ba3da9fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "804fe6b5a3e445bbd466367305f88c38dfe143b838748190a215739f010b1d85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78339c7f14ae204cff0ee9afd78eefe794fd24f6f543d4de0acf44ad3a785c60"
    sha256 cellar: :any_skip_relocation, sonoma:        "905143626266182328ebca597091e4905c3dee60a06459761bcac2dea766ad4c"
    sha256 cellar: :any_skip_relocation, ventura:       "981d393c55a6375a33aead9f0b73bd7b0d5db7e197069abe97832dd474816a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a934ce5e2de44ded9a76de790e60dc253bec0160a4f447d76044dc16592534b3"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-30
  disable! date: "2025-06-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    assert_match stable.specs[:revision].to_s, version_output
  end
end

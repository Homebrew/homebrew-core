class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.11",
      revision: "2195eae9e91f2e72114365d9bb9c670d0c08de12"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e1337c2cb4ac442356f396bd4c00c199d7af7811fc3d4fdf509de79e41c06d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2610684e78e422e96ab7ac42971b3bafca2c091e3d1b95c7707504a92e917c2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cca7a5c09a5262dd39c9b2886aaaa1a94f7e330f69b70d2b7e8b68c4ac07f6c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7f32cef4bcd481bae7b76693d97b75b3aafe9e4ca86d8e4fc8e3b8a1150371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "110f466ad3906e86d5cdd5d802c8230526807dd0562c1d393f1183b9f92efa82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3850fb68b729c31730609a5eb9b3f13fb6931bbf110ac81e6087ebe8145cb942"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-32
  disable! date: "2026-02-28", because: :deprecated_upstream

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

    generate_completions_from_executable(bin/"kubectl", shell_parameter_format: :cobra)

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

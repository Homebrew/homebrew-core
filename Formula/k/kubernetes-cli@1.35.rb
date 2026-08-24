class KubernetesCliAT135 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.8",
      revision: "1c2e10a409eb1b03f2f28f401ce935312e20d9fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.35(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0ff2018ac224d639a5313f448c9d6101209bea3f0ca6fa4281e4cedbd1b6624"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bec2f8f84038e996263b3f51fc56e45cb5b4ecfefa4dd406e95b0b04f9709b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f9fa2302ef2ee2c723960f06b790edd8e4a594ba6443f6115ae48ce50bfeda"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b8507c5a268f797eedc38e585121aacd72cc9e2344db26b6141c243c30a9979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "930814bb286f87940bf7c957aff0404410f712876753d2618ccc329f4bc64a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f76fb2d12fac891521adde8981cdb11e4e3acb46e130b2d0536b5baccb2002"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-35
  disable! date: "2027-02-28", because: :deprecated_upstream

  depends_on "go" => :build

  on_macos do
    depends_on "bash" => :build
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

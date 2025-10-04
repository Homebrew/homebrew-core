class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.1",
      revision: "93248f9ae092f571eb870b7664c534bfc7d00f03"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54ac8e6ea20394fb043394f748a76f83be6f0c03e73c38166833b3c634103d00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840f93ba6a2c621973783f87e1823ab6b7f5f1dd7424b0057de9cfd47bd65991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e66cc73e5ee2be577d9b1b9ee832d455e131b7b1a0d712273b9c0e056878d69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4314de40cbea9b9a549dba72662eb7543249f90cb8cc27628c314b315521cabd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cb6ac3fe6705f337300ff385ae70f1676269d4476452fa623f41d0ffb058211"
    sha256 cellar: :any_skip_relocation, ventura:       "dfb415ada40ec970bbf0c1f3b240c15ded56c5fc2d0c0b786a1478eb1949cef9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bee426caa863c12ca552f433a2f09f0f5aef87d3e3deb04b3517a4d70217f189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba5ed534bfb4c0f06b3ed4e747b3cebeba1e3464ee1bce70c417ea56259d28d"
  end

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

    generate_completions_from_executable(bin/"kubectl", "completion")

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

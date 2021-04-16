class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/v1.20.0.tar.gz"
  sha256 "9a5fdb94bc0a6eebe8eb4a7258af26b6fff0509f42e7559b03749fcfaf054112"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "050c1b8881a85fe53e5f7bdd6306fe8ccffb84ebf666de70e31679ac054990f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "26af35cbdee3b7b5b1ea9a30cfdb4edead627dc75c6121af9151ed0e27828c5e"
    sha256 cellar: :any_skip_relocation, catalina:      "e125eba162a59ec33c39ba1377b963c8e9a99f0a93780c0a4e55e45b41e3dc51"
    sha256 cellar: :any_skip_relocation, mojave:        "5be4b01c4a94bcb8f60b941cb2f0495ff4298ace48c4607aaaf01266d89d31ac"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end

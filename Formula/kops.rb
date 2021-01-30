class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/v1.19.0.tar.gz"
  sha256 "5cd8b8ab1e0412c9bb3a40d166653d8f447448c62478e029fe2d68b593e4c6dd"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "efc7c3228bc67151994f0a943864d07ab8fea13a37c94dafe7a8b7a9b724558b"
    sha256 cellar: :any_skip_relocation, catalina: "9d441d1122e641b047a029c52c4722837be0708e285433cbfec108d9687121af"
    sha256 cellar: :any_skip_relocation, mojave: "57ef9d56d07826a31ce2a6776f32acd6da0ef493e3fe36b2e34b287a46492c6d"
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

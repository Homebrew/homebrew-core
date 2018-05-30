class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.9.1.tar.gz"
  sha256 "f725a2b2e9b94e24aaa965981f5126bcc65089197352efbd64c6dfa48f28e7d8"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f4045b67f382260fbb8d6656b064b73fb5cc530c75a9505e47c39c9f06a4c95" => :high_sierra
    sha256 "53b20962447aef2d0844b443db45b41956f5e0d51bf87939634f7f3cd4ea7a69" => :sierra
    sha256 "c67f4f62829834d028e8a56cdaf4b5ccf6aed26221892bf70374ac342f492f81" => :el_capitan
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
    output = Utils.popen_read("#{bin}/kops completion bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kops completion zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end

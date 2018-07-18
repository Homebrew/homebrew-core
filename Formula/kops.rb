class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.9.1.tar.gz"
  sha256 "f725a2b2e9b94e24aaa965981f5126bcc65089197352efbd64c6dfa48f28e7d8"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "584d24587ad84553ddd7b4e8ff377738282257d86e328a0f048ae157f0a6a01e" => :high_sierra
    sha256 "7b49bc6fb95532eaa1be6a72dea1c0edc7dcdc1928731bef60ea99acc93d4f95" => :sierra
    sha256 "156e2c7124880447e211b34c18ae66320a1319635e12471c4c73bb69b357cbd2" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.10.0-alpha.1.tar.gz"
    sha256 "a8e3283361210e5be74746b58609ab88939553ea9c96095eca77088369b0c380"
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

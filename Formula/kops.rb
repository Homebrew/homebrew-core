class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.16.1.tar.gz"
  sha256 "720054de39fbb270397558a2eb47a8f4cbbfcacb9f792857c77d2cb32f56f764"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eda0d9df8cfb8366430973a7e7102e42f8740c976db0faa684a5c194cfd7110" => :catalina
    sha256 "cf816d4c78b3318f4cfa80542858f07ece2e2bf38741a17c6dd7e486f20fac81" => :mojave
    sha256 "8c010826e2d21041785add51dd9f2de8df67f984d57b5fc96cf8fbb717758a83" => :high_sierra
  end

  depends_on "go@1.12" => :build
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

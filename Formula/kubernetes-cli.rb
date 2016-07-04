class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.3.0.tar.gz"
    sha256 "77fbc5db607daa723e7b6576644d25e98924439954523808cf7ad2c992566398"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c2afb7e7b7fcc5f81d8b139c0bb6b6fc19a1269b8e0cf5fb5f956260554e00b3" => :el_capitan
    sha256 "dbbf24d98fdee97b0675c6be8233ba5795c60508e8a2d02c9d3d254fc08517c5" => :yosemite
    sha256 "f4178cff5b72929e176095cd4c734b3be6c77525028381da9793b02dcd474ccb" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.4.0-alpha.0.tar.gz"
    sha256 "7530fabf418fccf7bef08281efa9a51d86921726c8efac4f0e63ba1e87d83482"
    version "1.4.0-alpha.0"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
    (bash_completion/"kubectl").write `#{bin}/kubectl completion bash`
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
  end
end

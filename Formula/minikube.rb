class Minikube < Formula
  desc "Tool that makes it easy to run Kubernetes locally"
  homepage "https://kubernetes.io/docs/getting-started-guides/minikube/"
  url "https://github.com/kubernetes/minikube.git",
    :tag => "v0.26.1",
    :revision => "6ded2b647d1b1f62100c630bcfcc1363c631ce2d"

  # Docker required for non-Linux builds
  depends_on "docker" => :build unless MacOS.version == Version::NULL

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    repo_path = buildpath/"src/k8s.io/minikube"
    repo_path.install Dir["*"]

    cd repo_path do
      system "make"
      bin.install "out/minikube" => "minikube"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minikube version 2>&1")
  end
end

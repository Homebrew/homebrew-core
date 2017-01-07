class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.5.1",
      :revision => "82450d03cb057bab0950214ef122b67c83fb11df"
  revision 1
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    rebuild 1
    sha256 "5915f66fb4bd94b867820b9516989a50bb1028f2c41161aa47b09e5fcadf9df7" => :sierra
    sha256 "709be588857014657d47db971f3051d3c2692dd90a833c9323a707b4767322a6" => :el_capitan
    sha256 "b74c7f5f6e3e89a9e9fc7bb74eee8155087105c353ed01820b5e3866e913295b" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.5.2-beta.0",
        :revision => "5f332aab13e58173f85fd204a2c77731f7a2573f"
    version "1.5.2-beta.0"
  end

  depends_on "go" => :build

  def install
    # Clean git tree
    system "git", "clean", "-xfd"

    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }

    # Make binary
    system "make", "kubectl"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end

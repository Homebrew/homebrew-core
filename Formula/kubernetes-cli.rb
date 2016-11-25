class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.4.6.tar.gz"
  sha256 "dcbbf24ca664f55e40d539a167143f2e0ea0f3ff40e7df6e25887ca10bb2e185"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eff8827a884114a99f33884cd46cd3b72109f5921b3555a17346db715fdbaa3a" => :sierra
    sha256 "fe8165b68a2a7522932a34315ecd5de327652d8688ce4830fd49ebc1f869dfbb" => :el_capitan
    sha256 "a286f94b04bfa608735ceb003e75e34cfbd46fb49c379f2486051a64b9d52f47" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.0-beta.2.tar.gz"
    sha256 "3f7a1e2919264b421cfbb7b7cac3f09ad6b487f61253874561d61305679d76f4"
    version "1.5.0-beta.2"
  end

  depends_on "go" => :build

  def install
    # Patch needed to avoid vendor dependency on github.com/jteeuwen/go-bindata
    # Build will otherwise fail with missing dep
    # Raised in https://github.com/kubernetes/kubernetes/issues/34067
    rm "./test/e2e/framework/gobindata_util.go"

    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl", "GOFLAGS=-v"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end

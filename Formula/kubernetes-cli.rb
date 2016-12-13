class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.5.0.tar.gz"
  sha256 "0992af9e13bf756f0fb2abf08cd258631d08103cf833bb62936f09d2d5c60eb3"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "337214c2e6b19db9552ce623ecae350394c728012c58b6bb60c7bcd8afd06c7b" => :sierra
    sha256 "4ff383f14064886c0b5206614d582842f17cf633e7041c4a5b579904a3eec219" => :el_capitan
    sha256 "502f1126761078740fa19b10f7561dd6267e88c5311604ee7703c12d90575fb1" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.1-beta.0.tar.gz"
    sha256 "98582a12d32552694c4974a018b97c9d2e8c072befa5ab464d1d43fd35500b0d"
    version "1.5.1-beta.0"
  end

  depends_on "go" => :build

  def install
    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl"

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

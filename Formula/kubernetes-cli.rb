class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.4.tar.gz"
    sha256 "20a3984f9c044f1a1da3088166b181f3c10380d3efd4bf3fbc64678fef279ced"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3048d47f8f76cf3a7810ddf32fa8033de19e176cc6580517baac0c9cf1cd2f91" => :el_capitan
    sha256 "efc627b0b7f8ec3a303c12f7c744a865e0f02bb8f566f196ba2a1b6174a81b81" => :yosemite
    sha256 "fdff09be5f09b4963473687269166ebce01bd738ea90fb65881b8ffced5f6559" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.3.0-alpha.3.tar.gz"
    sha256 "887bcb59fb517124b22ca683d1161aff571a86e42b48e89ba748629a4d259992"
    version "1.3.0-alpha.3"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
    bash_completion.install "contrib/completions/bash/kubectl"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
  end
end

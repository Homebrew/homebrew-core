class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "bf7c686c3ada070104f32fd3263686368cc981206770e81d39d8a27ae04368c0"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kwok.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c9829a6287114e9ca679cd313933facad7a57b2aceacd0a5d798b2f1d62927a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a802cd90ce86d92663520b4a243db27ab70989f0afc9fd3e452faf679078262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb3a5257ca085b1854f846d8efa01a9394699f3a1d9c6ab749a6c6d6c1ed0cc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a706a400c14a9263eb584fa70f3106cdae304f29cefc13bb8d3511148df225"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "335471ec0aedf121022f660336be8989cba4f124904733ac5145b6f03f87a550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ca81c0287d077692b4e1c69b426efa10f0cbf01015a4375b6c8856354cad44"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "make", "build", "VERSION=v#{version}"

    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "bin/#{OS.kernel_name.downcase}/#{arch}/kwok"
    bin.install "bin/#{OS.kernel_name.downcase}/#{arch}/kwokctl"

    %w[kwok kwokctl].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/kwok --version")
    assert_match version.to_s, shell_output("#{bin}/kwokctl --version")

    create_cluster_cmd = "#{bin}/kwokctl --name=brew-test create cluster 2>&1"
    output = shell_output(create_cluster_cmd)
    assert_match "Cluster is creating", output
  end
end

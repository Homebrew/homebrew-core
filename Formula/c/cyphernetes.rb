class Cyphernetes < Formula
  desc "Kubernetes Query Language"
  homepage "https://cyphernet.es"
  url "https://github.com/AvitalTamir/cyphernetes/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "7547e10c1776d59a4744c5e91f1723c9c382cdce65da73948fb6424c90c06fd0"
  license "Apache-2.0"
  head "https://github.com/AvitalTamir/cyphernetes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9aad0b201d8f6bc34a97ac1da7784f1ceab865321577fc3687a15f1d87e9dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f9aad0b201d8f6bc34a97ac1da7784f1ceab865321577fc3687a15f1d87e9dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f9aad0b201d8f6bc34a97ac1da7784f1ceab865321577fc3687a15f1d87e9dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8495f244906bd38f6ec3b29700b887412c9f13100fdf11e75e11c3914ef610d9"
    sha256 cellar: :any_skip_relocation, ventura:       "8495f244906bd38f6ec3b29700b887412c9f13100fdf11e75e11c3914ef610d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "295f7a3df74900d3832f7ae150e7e897b960c6ba0c4684d601a27c400b3f0801"
  end

  depends_on "go" => :build

  def install
    system "make", "operator-manifests"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/cyphernetes"

    generate_completions_from_executable(bin/"cyphernetes", "completion")
  end

  test do
    output = shell_output("#{bin}/cyphernetes query 'MATCH (d:Deployment)->(s:Service) RETURN d' 2>&1", 1)
    assert_match("Error creating provider:  failed to create config: invalid configuration", output)

    assert_match version.to_s, shell_output("#{bin}/cyphernetes version")
  end
end

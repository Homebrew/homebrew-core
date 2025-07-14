class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "32fcd55671f241b7a782400e1bf1c762f9729526850e7eda08f56451f12268ea"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dd60f52284f2aa41b0583a8fecb1374e5783522e85e5798198d913c2df6be6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd60f52284f2aa41b0583a8fecb1374e5783522e85e5798198d913c2df6be6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dd60f52284f2aa41b0583a8fecb1374e5783522e85e5798198d913c2df6be6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aac5b104c34a17b82384b58921975cde430952ea32dbcaac6ddc61387d5fe27"
    sha256 cellar: :any_skip_relocation, ventura:       "5aac5b104c34a17b82384b58921975cde430952ea32dbcaac6ddc61387d5fe27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda1ac55ddad86f969d5849ce0293ee57407acf0d0f7968211d80f63e8f8815b"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kind", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end

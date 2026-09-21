class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "8b00b127eb567f30b028cb032d236d990404e9fd83ce7798db7f9c7a305fab34"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46bb165d45da3455acebc0492b9bdfc633d516bf7069ea85fe5ddda965d48ac3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c9b4ede94b65b91d21dfc0517904a4e3ffea3e37be47289b1178bb9c7aac916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c9b4ede94b65b91d21dfc0517904a4e3ffea3e37be47289b1178bb9c7aac916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6c9b4ede94b65b91d21dfc0517904a4e3ffea3e37be47289b1178bb9c7aac916"
    sha256 cellar: :any_skip_relocation, sonoma:            "9722eb27982aa3b12ede37bdd7e08067a43a07e770f9b16f07c6ead5808ec74e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5dea5933df7babbf42a6a8b43c0ecdb956ce55fac65e8bd02ba73f04a0e30084"
    sha256 cellar: :any,                 x86_64_linux:      "b4af3c404e2c6c1c606ff9cf051da6073eac1c0307f230f2f770ab15993d10bc"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"kind", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "failed to connect to the docker API", status_output
  end
end

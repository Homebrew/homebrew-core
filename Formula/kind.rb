class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.16.0.tar.gz"
  sha256 "28b85260e326dc6b5baab28b927dcbf73f4f48c276364310ea0a7c9bd5e69f51"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adba6b3bada0a03dcece1479e1c7ef9f6c00c46d4206c80df4145e301d13960f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55275447102a467ac29e6f5eb1cf027b4d26acfbbb10bf55f4c1ec3fa00ca9d4"
    sha256 cellar: :any_skip_relocation, monterey:       "4ddb53469f6d8b75a87bc359587b5a8b713eaf70b97e06d6578cd41f67dcd196"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca5a8b5169c2d649d0f6b0bd5ccfb9fcd13ba308d4d171fccfd1711eb16b3ce3"
    sha256 cellar: :any_skip_relocation, catalina:       "5fbc6678432a9d03d619c970c6e34de1fce5f8352acc285bb025d5d1c11f6136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d883a4e284b2d262751be3de2d6cbc44d2293e65aee7db99dcfc06cefcf1bb2e"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"kind", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end

class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "eb7bcb8005ff980d7d7ad088165a5a6236f484444aa397520cd98cb046e1d797"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d608a295d52a769cdefa9f49c5d84bee01e21119016dd4870960a0b85b9416f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d20522ec44b43bfa7c01d4c71a2d87acb7280bd59c26c3f29e18aa349f462eab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a364ca7bf349559bea646b85a29b51a7988080fe0ef513810abf8118ca6aa65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "536aeaba5a28504851e82fd6d9b1bd6f667483d91b887a4de10ea5d4938d20fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfc12516b85b818ffa62771de78abcd2423a92b601bca91dfc8ba32311b54077"
    sha256 cellar: :any_skip_relocation, ventura:        "cd2708f283c9f9e66798e095b08e971dc19ad8011ca984c6a7fe99004157f830"
    sha256 cellar: :any_skip_relocation, monterey:       "498c534c5297b98df0ed53fca401fb9dd3edc07457d32788c71f76fb9b4c11e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64af9a5158b440abe6f6a2873d04f165281fd5ff58de292183afa7830702078f"
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

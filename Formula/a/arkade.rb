class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.33.tar.gz"
  sha256 "6aac8b88749e9721af04847ed283722887306a82566912299a73a70bd842e81a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17c201c7a7f73a50cfb41858ed0316a6c7fc046d8fdb124661eba5c64780c649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17c201c7a7f73a50cfb41858ed0316a6c7fc046d8fdb124661eba5c64780c649"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17c201c7a7f73a50cfb41858ed0316a6c7fc046d8fdb124661eba5c64780c649"
    sha256 cellar: :any_skip_relocation, sonoma:        "203ff80363d1c445253fb45b2557fdce2b3a16494476b1937ed25bb89b1bb62a"
    sha256 cellar: :any_skip_relocation, ventura:       "203ff80363d1c445253fb45b2557fdce2b3a16494476b1937ed25bb89b1bb62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2effff5fa488d101ad4a6c7cc8b9e733beeb01f48682f9533bc28bd4ae9d14d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end

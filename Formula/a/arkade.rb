class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.59.tar.gz"
  sha256 "2280a514fd2d7f9f4233f05bc81a314b7a74dca84abe73983625bf63e89c00e8"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbbab5372ba6b1dcdfc56a5ecde32f035a9b0197da81ca27f77bd3d2311bf171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbbab5372ba6b1dcdfc56a5ecde32f035a9b0197da81ca27f77bd3d2311bf171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbbab5372ba6b1dcdfc56a5ecde32f035a9b0197da81ca27f77bd3d2311bf171"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec0dd55390cd6102be1f988a5be4c296d1b0970b1cbcc8c4f098f28aa1a351da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e6cc9b67cb338a4d2546e5a7ddf1ec8fcb6747f0e9f226842f626713794f4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76c63fa9b229feeca5b5122fedaea51a739587b26cf971938e207707a1839b15"
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
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end

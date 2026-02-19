class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.81.tar.gz"
  sha256 "d49ce3c24d0678d75d9c73e28fd782f3f7f4ada0f57621a3a9a05c0d9ac7ab4e"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b52e95ea848cf73784059866c5edd5462688b78329de8d59761c26037b959093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b52e95ea848cf73784059866c5edd5462688b78329de8d59761c26037b959093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b52e95ea848cf73784059866c5edd5462688b78329de8d59761c26037b959093"
    sha256 cellar: :any_skip_relocation, sonoma:        "88a4e59114bc7b498ad9e1436b13de4009b29ab382498503eaa411068c624b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40e7dd12a739b306abd59cd12457adddea4f329bd4cc9f7c77231bfa18dc17ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9593541a1507af10a2eac8202343ed01967456610a9763bd2bb638343724e227"
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

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end

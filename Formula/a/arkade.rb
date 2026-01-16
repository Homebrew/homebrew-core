class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.63.tar.gz"
  sha256 "79aeb4aa1bf5c9df4cd93b4598a571cbd40ee65e749bb7772987f269c56eaf8e"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3beca06da1dd298f82965ba6f4913c0685617bddd8f703955f2b5e199b2208ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3beca06da1dd298f82965ba6f4913c0685617bddd8f703955f2b5e199b2208ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3beca06da1dd298f82965ba6f4913c0685617bddd8f703955f2b5e199b2208ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "226e27e46524650b24b51839013e65bca9d7a01ad8987b3bf150c7d3a8f82f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4cbf1c1eaff4f9557f89414d6d017eb901ec4b2a56d12d97cfe20a9f5ae855f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68cfb11fa3358eb2530cb14a6bb41d74d7e0d304cea55c07e1f801176f320c34"
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

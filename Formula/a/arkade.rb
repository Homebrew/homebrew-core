class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.69.tar.gz"
  sha256 "790da4e453d462afd7fcdbf49f7952590f78298ebdfec39068ced0cfec2dfd08"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "588fb94dafbb03fefc98fc8665b8bb175e7f4c696e4d391ee9a46477f48f52f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "588fb94dafbb03fefc98fc8665b8bb175e7f4c696e4d391ee9a46477f48f52f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588fb94dafbb03fefc98fc8665b8bb175e7f4c696e4d391ee9a46477f48f52f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a21d6cc60ec679ec557dbe2c755071bac3a84aeeb088bbe5218e365bb3fa66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "471c080986fc38ad4f6288cd3ecf887454deecaff3fa8f800820afdf8a391ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acee08be9f0353452aa62726c95fa1b8ae5c52cb1dcf3971dd1da168832a791e"
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

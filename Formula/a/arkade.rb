class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.38.tar.gz"
  sha256 "92ba8fb2553c7e822935d1a12c2a0fda35440c061838a42bcd400b820ef2336e"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a452f0267606c8bac21d1e24b4c31b0d8ebf1579abfc109a4f7b93ad757ba0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a452f0267606c8bac21d1e24b4c31b0d8ebf1579abfc109a4f7b93ad757ba0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a452f0267606c8bac21d1e24b4c31b0d8ebf1579abfc109a4f7b93ad757ba0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0113b92887eb011bc8cf7f865f2bdc81cd7593971af00874b25fab1fb18d11b"
    sha256 cellar: :any_skip_relocation, ventura:       "b0113b92887eb011bc8cf7f865f2bdc81cd7593971af00874b25fab1fb18d11b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a39722e9eb5c0b9fafc0d3c8eb83f87077b7bea1263dc977adf43cf5174375b"
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

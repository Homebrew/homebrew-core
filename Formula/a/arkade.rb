class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.39.tar.gz"
  sha256 "d946f8cb065ad7afbfed1e1bb37120bb767cbed7b8088bfdc474689edc2189e4"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d216067e0b940c8727631fb06a895a95ade33628fe7955c85c0607d937776d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d216067e0b940c8727631fb06a895a95ade33628fe7955c85c0607d937776d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d216067e0b940c8727631fb06a895a95ade33628fe7955c85c0607d937776d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eb69d1d13660317ec0a4384a355b0a2010ea5d15007fbcb4cfba5ede4cb1027"
    sha256 cellar: :any_skip_relocation, ventura:       "7eb69d1d13660317ec0a4384a355b0a2010ea5d15007fbcb4cfba5ede4cb1027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb3f3dbb68ab219fcbc01c832320d884def4459a8358dd159f7d993b5792ea10"
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

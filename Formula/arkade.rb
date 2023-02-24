class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.2",
      revision: "302ea08874bf21196930a9938e9f3b2d6f1d3fa7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e25c3e836f5c1c1914c4e27608605d8c23905100b9dca0f621cfaa668b2a5f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1150c572d3a45c06bf397beaa048223aad73010c9eadc2a9b9cfdd4984719c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cffce83c442ca2a47aa1315f798a80fb940e02185614538b436b305be8c2a6c5"
    sha256 cellar: :any_skip_relocation, ventura:        "c75e53ba9977b72decb21a71f1e254f92bd7aea3d1d5571908a1fdd00381e8a2"
    sha256 cellar: :any_skip_relocation, monterey:       "82b78732c35295caa3757d2541027aa2d0994050bfda9e862d8ee01b8d99ec00"
    sha256 cellar: :any_skip_relocation, big_sur:        "a31d2a4d85347fae4eeaf8e272799c7ac9f97df88b48c50abeaa029a52e47978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41e2758fdc07087978610c3fa86ea7daea7393cde5f2c478a83ca80f30244ffd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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

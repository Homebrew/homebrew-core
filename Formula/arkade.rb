class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.61",
      revision: "995b69f9c7aef7f1d851d57be60262d128ee8e65"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f415e6991df421e4f59256dcfb64425eac63ab48afe3e9274e32117e47371252"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60f69728f5f72df0c59241d7d9accb72ede86875ddb43caa4cfd71ad6472e922"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c5d85ebdcc5b7c7ee425cf08da4d4597b649f25cdc012cf2cbeadb2caed148c"
    sha256 cellar: :any_skip_relocation, ventura:        "f01f9cb2faec085e89276bfee709786194244a6fb9eb0198e62f6a6a34b5eba3"
    sha256 cellar: :any_skip_relocation, monterey:       "49d21abf1b1c8f431343e6a36b66c35110045f1ca87e9eaddf3629c0d94aba51"
    sha256 cellar: :any_skip_relocation, big_sur:        "1539394049b64743b8143dcf965466b15b1e2934c114f473b04d9798599b68c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d207f1f3285abfee8e57a5af693eece3ca34e6e9df0069e1c3004dc85a7e8e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
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

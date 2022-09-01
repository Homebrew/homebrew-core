class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.39",
      revision: "2e76c2c3681a3796b03483c3c04fb2ebcba0fa3e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9ec1f6b098e04d2b5b939e33d5d40c41be5d01fea4a531cd98881530c8b38cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "461e84f60fcd40ba47125bb052d887a972f537cf1c41bac0c5564bae0c4e1618"
    sha256 cellar: :any_skip_relocation, monterey:       "384fa5712c80434c5dc56b87fed4bd5164ba751ce31fad5f56a09f0e5bbde234"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab01e31f81983a4f3502a850e9217f1c3aa047d850f09c29d68aa35aa96cc180"
    sha256 cellar: :any_skip_relocation, catalina:       "ac63515ceb487150d529294b8970304d072ccfa313f78b0d4e8e8c49c0efc1f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7287cdbb3193970f4df324dc6453d10315641c4498d9f22666849a58f6134e"
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

    (zsh_completion/"_arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "zsh")
    (bash_completion/"arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "bash")
    (fish_completion/"arkade.fish").write Utils.safe_popen_read(bin/"arkade", "completion", "fish")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end

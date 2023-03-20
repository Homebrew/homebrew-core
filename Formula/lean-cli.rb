class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.2.0.tar.gz"
  sha256 "76bdb5395cd70783dff2a4a7bfbf9fb680ba9fe4beb43dd47bd355851b594b4c"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c91fcf6cbc89a58570cee5b69bc222dd45b90908e63fc9034ed45ae97c3d50c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c91fcf6cbc89a58570cee5b69bc222dd45b90908e63fc9034ed45ae97c3d50c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c91fcf6cbc89a58570cee5b69bc222dd45b90908e63fc9034ed45ae97c3d50c7"
    sha256 cellar: :any_skip_relocation, ventura:        "ceeb0a761fbb486cb6dd9dd3d2140ec6eedd799abb0531276b977037fa43f3cf"
    sha256 cellar: :any_skip_relocation, monterey:       "ceeb0a761fbb486cb6dd9dd3d2140ec6eedd799abb0531276b977037fa43f3cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceeb0a761fbb486cb6dd9dd3d2140ec6eedd799abb0531276b977037fa43f3cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8faf49143012dac8b0a992e4fd1d0bdb53e97f667d68431f756f8df83070477"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bin.install_symlink "lean" => "tds"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    output = shell_output("#{bin}/lean login --region us-w1 --token foobar 2>&1", 1)
    assert_match "[ERROR] User doesn't sign in.", output
  end
end

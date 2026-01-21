class GruntCompletion < Formula
  desc "Bash and Zsh completion for Grunt"
  homepage "https://gruntjs.com/"
  url "https://github.com/gruntjs/grunt-cli/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "0ed2f1bbe6ba85c5b2b3ae1233c52b7622db092c078aafbba75dbb435a6a9d20"
  license "MIT"
  head "https://github.com/gruntjs/grunt-cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b46d9b78c7353cfdc7dcea3a0009d9799ac6281b32484fca512db71258a23e5"
  end

  def install
    bash_completion.install "completion/bash" => "grunt"
    zsh_completion.install "completion/zsh" => "_grunt"
  end

  test do
    assert_match "-F _grunt_completions",
      shell_output("bash -c 'source #{bash_completion}/grunt && complete -p grunt'")
  end
end

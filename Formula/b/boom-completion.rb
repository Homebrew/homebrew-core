class BoomCompletion < Formula
  desc "Bash and Zsh completion for Boom"
  homepage "https://zachholman.com/boom/"
  url "https://github.com/holman/boom/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d107accf1fb84d9c245bb25383486179605d3b397c439c2f4690341283b0b2dd"
  license "MIT"
  head "https://github.com/holman/boom.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "05b587e612fdff3439b6618c062c1f7b5f13332e3b8e7645d80cf5d5f023d276"
  end

  def install
    bash_completion.install "completion/boom.bash" => "boom"
    zsh_completion.install "completion/boom.zsh" => "_boom"
  end

  test do
    assert_match "-F _boom_complete",
      shell_output("bash -c 'source #{bash_completion}/boom && complete -p boom'")
  end
end

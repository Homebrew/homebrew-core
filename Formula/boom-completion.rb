class BoomCompletion < Formula
  desc "Bash and Zsh completion for Boom"
  homepage "http://zachholman.com/boom"
  url "https://github.com/holman/boom/archive/v0.4.0.tar.gz"
  sha256 "1212ed265ef7c39298dd6630cb3f8838a120d77615301c0ee188e47501dcdef9"
  head "https://github.com/holman/boom.git"

  bottle :unneeded

  def install
    bash_completion.install "completion/boom.bash" => "boom"
    zsh_completion.install "completion/boom.zsh" => "_boom"
  end

  test do
    assert_match "-F _boom_complete",
      shell_output("source #{bash_completion}/boom && complete -p boom")
  end
end

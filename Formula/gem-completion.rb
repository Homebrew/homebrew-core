class GemCompletion < Formula
  desc "Bash completion for gem"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby.git",
      revision: "f3e4345042b0cc48317e45b673dfd3d23904b9a7"
  version "2"
  license "MIT"
  head "https://github.com/mernen/completion-ruby.git"

  livecheck do
    formula "ruby-completion"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "044d02a4211a0f89e550ff2f5779903cb443528f8f703ea2bd549bc39b9be595"
  end

  def install
    bash_completion.install "completion-gem" => "gem"
  end

  test do
    assert_match "-F __gem",
      shell_output("source #{bash_completion}/gem && complete -p gem")
  end
end

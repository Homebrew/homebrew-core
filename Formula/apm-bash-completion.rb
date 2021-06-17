class ApmBashCompletion < Formula
  desc "Completion for Atom Package Manager"
  homepage "https://github.com/vigo/apm-bash-completion"
  url "https://github.com/vigo/apm-bash-completion/archive/1.0.0.tar.gz"
  sha256 "1043a7f19eabe69316ea483830fb9f78d6c90853aaf4dd7ed60007af7f0d6e9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2801988299d591aeafbce230b0425f6f0b5737d0a37e702c47a19c4729cc492f"
  end

  def install
    bash_completion.install "apm"
  end

  test do
    assert_match "-F __apm",
      shell_output("source #{bash_completion}/apm && complete -p apm")
  end
end

class ApmBashCompletion < Formula
  desc "Completion for Atom Package Manager"
  homepage "https://github.com/vigo/apm-bash-completion"
  url "https://github.com/vigo/apm-bash-completion/archive/refs/tags/1.0.0.tar.gz"
  sha256 "1043a7f19eabe69316ea483830fb9f78d6c90853aaf4dd7ed60007af7f0d6e9d"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "b4060df6591f97ca99b076b034721b3f0a9636127d6dfd3dc234fcdca68c06c9"
  end

  deprecate! date: "2025-04-27", because: :repo_archived

  def install
    bash_completion.install "apm"
  end

  test do
    assert_match "-F __apm",
      shell_output("bash -c 'source #{bash_completion}/apm && complete -p apm'")
  end
end

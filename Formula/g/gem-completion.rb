class GemCompletion < Formula
  desc "Bash completion for gem"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "70b9ae9154076b561f0d7b2b74893258dc00168ded3e8686f14e349f4a324914"
  license "MIT"
  version_scheme 1
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  livecheck do
    formula "ruby-completion"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf301278a53387a05bbe44db4f921629211afb38be7057bcc60ff0088f5ebae1"
  end

  def install
    bash_completion.install "completion-gem" => "gem"
  end

  test do
    assert_match "-F __gem",
      shell_output("bash -c 'source #{bash_completion}/gem && complete -p gem'")
  end
end

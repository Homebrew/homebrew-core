class BundlerCompletion < Formula
  desc "Bash completion for Bundler"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby.git",
      revision: "f3e4345042b0cc48317e45b673dfd3d23904b9a7"
  version "2"
  license "MIT"
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  livecheck do
    formula "ruby-completion"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a933db603ecba2d78dc7bb9c88df00aa45d838e692bc5e6c00ef7d97d983ad6"
  end

  def install
    bash_completion.install "completion-bundle" => "bundler"
  end

  test do
    assert_match "-F __bundle",
      shell_output("source #{bash_completion}/bundler && complete -p bundle")
  end
end

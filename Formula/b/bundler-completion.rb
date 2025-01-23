class BundlerCompletion < Formula
  desc "Bash completion for Bundler"
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
    sha256 cellar: :any_skip_relocation, all: "f08e58b28795cd4563c8c7c868db8760b1a7fd0bb23fbfb75f31c999288df683"
  end

  def install
    bash_completion.install "completion-bundle" => "bundler"
  end

  test do
    assert_match "-F __bundle",
      shell_output("bash -c 'source #{bash_completion}/bundler && complete -p bundle'")
  end
end

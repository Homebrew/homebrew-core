class KitchenCompletion < Formula
  desc "Bash completion for Kitchen"
  homepage "https://github.com/MarkBorcherding/test-kitchen-bash-completion"
  url "https://github.com/MarkBorcherding/test-kitchen-bash-completion/archive/v1.0.0.tar.gz"
  sha256 "6a9789359dab220df0afad25385dd3959012cfa6433c8c96e4970010b8cfc483"
  license "MIT"
  head "https://github.com/MarkBorcherding/test-kitchen-bash-completion.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4477a44357f241518a1ebd61583623cfccee33e67c2046cd85ce6702a2ea54ce"
  end

  def install
    bash_completion.install "kitchen-completion.bash" => "kitchen"
  end

  test do
    assert_match "-F __kitchen_options",
      shell_output("source #{bash_completion}/kitchen && complete -p kitchen")
  end
end

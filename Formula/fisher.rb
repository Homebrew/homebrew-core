class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/4.4.3.tar.gz"
  sha256 "c49698fcc839554f453a7c557d860cd4ba0e9529f28f20f8134463af43aa3b6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86f35339a83f2985b49de0effa29cb19a3fc19494f030f022b72ba9ba06eb9e6"
  end

  depends_on "fish"

  def install
    fish_function.install "functions/fisher.fish"
    fish_completion.install "completions/fisher.fish"
  end

  test do
    system "#{Formula["fish"].bin}/fish", "-c", "fisher install jethrokuan/z"
    assert_equal File.read(testpath/".config/fish/fish_plugins"), "jethrokuan/z\n"
  end
end

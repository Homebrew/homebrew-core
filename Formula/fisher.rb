class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/4.3.1.tar.gz"
  sha256 "be4313076a57d05fe2e49a7bd1c2fa8fa2f041af837a31974cd1d8d1f397bf29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "958d97d06ad998382f7c9f77d7c4861c6b76542e4438660700fab7b2ddffb5f1"
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

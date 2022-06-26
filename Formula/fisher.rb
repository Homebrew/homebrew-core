class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/4.3.5.tar.gz"
  sha256 "a93b1e80f02fd8c880328a2cae00a2a745729b25fe94aa0d6e497c4aefaef5d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "529e1044768f9f03f882fbf4c73b237026547e2d7eb221cb5ad5b64fe71d7524"
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

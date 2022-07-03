class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/4.4.2.tar.gz"
  sha256 "619498141f0557ea7eeb4438a97c45748ea5d4c3645340b5464ebb4622af3f64"
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

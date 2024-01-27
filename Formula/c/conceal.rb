class Conceal < Formula
  desc "Trash collector"
  homepage "https://github.com/TD-Sky/conceal"
  url "https://github.com/TD-Sky/conceal/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f1f9bd859e9bbae1e9a11f5f2292a476dacc5bc3da483585dc8e4862a98e6976"
  license "MIT"
  head "https://github.com/TD-Sky/conceal.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install "completions/conceal/_conceal" => "_conceal"
    bash_completion.install "completions/conceal/conceal.bash" => "conceal"
    fish_completion.install "completions/conceal/conceal.fish" => "conceal.fish"

    zsh_completion.install "completions/cnc/_cnc" => "_cnc"
    bash_completion.install "completions/cnc/cnc.bash" => "cnc"
    fish_completion.install "completions/cnc/cnc.fish" => "cnc.fish"
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"cnc", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end

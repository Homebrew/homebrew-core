class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.9.4.tar.gz"
  sha256 "70c0d6cbc21b7d4e993cd0218d89f82e86498ac86762e785dc2fec6c65202905"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7007d784dd56ca0c596e641e96b73ee32ac21fd30f93d11af0f434df01c9c4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "87760e80e1fd21b9e4e31b4e087733a1f747ba09781e20c94a13ccedae04c717"
    sha256 cellar: :any_skip_relocation, catalina:      "930d9a441bafbb63240d3052dfbceaf812b2b2bfa60431283679d8ed1d98bab7"
    sha256 cellar: :any_skip_relocation, mojave:        "9f5fb1dd103031ff0a4a05f86b12b82a0361244e8188e0a13842ccbad7e235f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end

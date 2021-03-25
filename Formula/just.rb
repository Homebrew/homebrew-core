class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.5.tar.gz"
  sha256 "8b252a71308fd71d9735f9a9eb221365f04695ba6961d4035e22c3ec00a50f93"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c7d60eec77ed7c0ec403b2020d0658be9880801ee1fafeb5d282677ed83bd47e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a37ec2800f7eb0b2f959f1905f6de5fb42f451a9cb3aff2af3013bde75fc34bc"
    sha256 cellar: :any_skip_relocation, catalina:      "d95384356d722e6e6e99075b4033f6bc755968d53b137b64402733c982fb6219"
    sha256 cellar: :any_skip_relocation, mojave:        "83c60ef6c68bb3c90235db6bc24977612d1925b72d8fdcde3eb53af2df0abf97"
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
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end

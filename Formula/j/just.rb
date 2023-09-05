class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.14.0.tar.gz"
  sha256 "021d4dee59ddfd86ab87b9c9423b9a8126932c844da9765a35eb1ccb8f6cf4ce"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d7b2cd7fb280dbe9bdfb365b0eba775fbe467d51760a247130ddc2f23ef382e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "085625e36867272e81b8870907a063babaa9c14c3fdfd04e4584e7c808363c14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e91a75faf9d618a388d0f7245f92edd72d3c7654682a40f4f57bbd396ebacf5f"
    sha256 cellar: :any_skip_relocation, ventura:        "cf499f26cdb67badc7bbc6e562d7adbfad300b29a64d1eb76febca245a26d8cf"
    sha256 cellar: :any_skip_relocation, monterey:       "5d2116df04de9e9f00b4754c4f60152991bc81ae0b3acd61c369348e08d72b55"
    sha256 cellar: :any_skip_relocation, big_sur:        "e33d9aa36f7e32a029cc5ab371b48be1250c2dab0c76f1823f6f2ad3b52714b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec55b92f82be562549c029523a8e8e758c9d823adb96e0a04f80bb3e8e0932d"
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

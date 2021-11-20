class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.3.tar.gz"
  sha256 "10ee1caaedb2e92257338942fce146e5d3aadd6f9f5e98fbc21e422e2d863169"
  license "CC0-1.0"
  head "https://github.com/casey/just.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ff0dd66e2ca94e429c204f990a11ca52bfce3fb5051cc8534fba89d91d65bb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac90100a299641baa3ef243ccdcdb970cd2562fe57869202e471ad5b6bed211b"
    sha256 cellar: :any_skip_relocation, monterey:       "8bbd7be3d3dedc0edb88c07a9bc597d4da220b13ee52d2bce77469a581e1a790"
    sha256 cellar: :any_skip_relocation, big_sur:        "47991aa412115942ede4dd66a5a6aaef794cf201b0a58998afd1df66b8cbdfcf"
    sha256 cellar: :any_skip_relocation, catalina:       "f78750b5ebba0d8a28563414f3980b59fe06d5b875896ae4e7359ef0160a6c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae345134746c176023d47a58eeb1d32eb59d386c2fa096f9ea0c7ae72a9a7534"
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

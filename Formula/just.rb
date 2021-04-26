class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.9.1.tar.gz"
  sha256 "ac3eba079f11447e58c06d3efd02a7c2fed9581de533db7f2032f217efdaa446"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "212df54161b6a5808f8a04179ef87b025fd759c512dc6d91f5e44c3cc0fbcda6"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cb461ecc3f52a30b0bc64886d6bfcdb5d5f4a3f334eb1b992a41768f3bd4e09"
    sha256 cellar: :any_skip_relocation, catalina:      "d5eb05b28329449d01bfe89969f3f00131eb942e4ace582cf2bfe4f6661710ac"
    sha256 cellar: :any_skip_relocation, mojave:        "d8eb1b2d98ba6e24c7e8b6b3f4712ce889bbf5bddc74492b4469cb2a22641db5"
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

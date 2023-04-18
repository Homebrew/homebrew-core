class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.13.0.tar.gz"
  sha256 "ead24ef982253fa4bdd0af27b0867f74c8d9528817be8dd8b14b182369a432c7"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17d5f83789b67b2f24f5a1bca7ed1a78073083c6becb25ccc08b54c39c7b2854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392a77bf6a76f4ca122f837e0f29c737dd979ec737f017edab0a371da323c246"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82d788a1e58408fb120f58cd35fe5859bbe218f6ab61c561e9fb8cc224029179"
    sha256 cellar: :any_skip_relocation, ventura:        "def7d79131017bcddb8ce2925a24fba91e6d27cf35a427261ddf70f08cceee83"
    sha256 cellar: :any_skip_relocation, monterey:       "1f8fea8d4052e082eff5496c274220ee419dbf8604ac3df6fc5b2287f233081b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7ee51bd5319b0a605558a67af51a4b855e6cff56cb690e90e937d7bd0f77f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4ba141908efed93915cee06bb66812cada234d98ffa965fe3c616adb84f7e9"
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

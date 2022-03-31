class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.1.2.tar.gz"
  sha256 "5f04ce85dc2de7609d68c336a7c51f477f8ff079d8b209a0d72183615e3f1e55"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e33e436720eb7e971e94f965d9e9995e115f8c941932a2a695ffa139c5175752"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dac0b492c47a0a0c2e0288f385dfd9fa2c35966725a73bc5e202fefa734a0531"
    sha256 cellar: :any_skip_relocation, monterey:       "e79f607fc3684c703cb21d6cdbb42039ab19ca9e72aa75f47e9c7ae53902c76c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7eacac2d7c5f2180229202e13ccdf6c2e113d99bb6e345a07a7716e0b022884"
    sha256 cellar: :any_skip_relocation, catalina:       "5c4bf41e4993ba254fe0c8b09a616fc79be5bcc6d39f887168bc4658065424f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dff4eb05ea3ccfbcfac6c17d3503d42f8e4a9aba40b961e6846344ef28bbe9f"
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

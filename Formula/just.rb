class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.6.0.tar.gz"
  sha256 "d33e656843bc280795373249f5f23f2d6c87aee9dd970058a1c6257b2843bd9d"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7eaa44526912e4df814ce1181fd84c37333ed79dc702521f7279aedbe09920b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6594b2f9484ae97d80346cb5feff6205f60848b4b0f3cd84466e81a09d4fea3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efab8b4c4fda728c3126e692c9b14665180a65b5f0c2c8caaf8bac673cfb6f77"
    sha256 cellar: :any_skip_relocation, monterey:       "5e8cf0e5c47ae9abd446c704361327cd3fd42cc7a135a8d3d4d0d4c8a8974990"
    sha256 cellar: :any_skip_relocation, big_sur:        "88d54f20472e9d4bb55ffa38bd197138bec96b27d8571e30372513588ae586df"
    sha256 cellar: :any_skip_relocation, catalina:       "419fad95f38d1abe95a6fc8729eb4c7b96834b5f65d6c1a8a7a63a2c017d5011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600f528ecd28555dcd267f117d3262ae019d4fc55bda4f3ca461f2b586aed2c4"
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

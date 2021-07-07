class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.9.8.tar.gz"
  sha256 "0c464c3a06d40e68e1014e583ec1733aa16bca5796fb42874438dec9f4a464a4"
  license "CC0-1.0"
  revision 1
  head "https://github.com/casey/just.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89f93b8233efe610afbfd20e42bc016b7c2d142b6d98035f7137d00efafdfc27"
    sha256 cellar: :any_skip_relocation, big_sur:       "65dc9fba03dd0487e375bde49ebd923d78cd3c7d7899cccfd18be0363176e468"
    sha256 cellar: :any_skip_relocation, catalina:      "fa1ff7ea815cc5fd8326fe656babc906c56e9e0326071ea492bcc1906bc64bb7"
    sha256 cellar: :any_skip_relocation, mojave:        "4b016cceaa4554f0b20731f34b70868607158947abdfecd05ac38ab4ecdc6ddc"
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

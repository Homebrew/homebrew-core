class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.67.tar.gz"
  sha256 "a2ae6816b9fd53d88cd2b866d9de7dee0ccd00ebb3cb14c35f975a28224e8ed1"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f394baf970723999437246f2205122b29c8b05a7b7bd368365d1bc4efebdbd5" => :catalina
    sha256 "bc4fd509f1d7e6254bf984e76de741f8c5dccef520688ef2caad1c420dbbc7d2" => :mojave
    sha256 "481c9854786036971dc3bb54ccddeda5f25e6a6493e9d7374114c04f07642527" => :high_sierra
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "contrib/completions/ffsend.bash"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system "#{bin}/ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end

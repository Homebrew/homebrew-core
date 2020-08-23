class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.65.tar.gz"
  sha256 "a07f1c45888df7ed061d2bb8c035a0b158b9d3c84d533900043407108ce953d6"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5090ef4f96a88aa9b705f5b6b28976eed11a41d2ba075d3c15cf423e55bb98f2" => :catalina
    sha256 "4368dfd715fe14f5112a55bb8dbdada32b397fd2915abf61940da7954c902138" => :mojave
    sha256 "16afb60046195e5ba30e5ee737e6e85ddc1fa225b8912bbb057e76c81e36be1a" => :high_sierra
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

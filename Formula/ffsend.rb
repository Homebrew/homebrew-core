class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.64.tar.gz"
  sha256 "bb4c435e864cd543075b3a35a9d6af62d51c7a1a1859e381518da0a52c073e99"

  bottle do
    cellar :any_skip_relocation
    sha256 "c15cd573b7db56f64cd020bfa2395d95468c265c6d9f0601daae87a0ab0362ac" => :catalina
    sha256 "f036ede55acf203ae062f862dbb6d08d244a205ca564e8401aaeb6b0885ecffb" => :mojave
    sha256 "624fe915583462af9d73f826d6e36211a627c6565052fc438524878f982611c9" => :high_sierra
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

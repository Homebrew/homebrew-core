class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.67.tar.gz"
  sha256 "a2ae6816b9fd53d88cd2b866d9de7dee0ccd00ebb3cb14c35f975a28224e8ed1"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb9b7d827e204f76f04e2e037a57eb423e482d509ee61a321b42f7eb39bd7928" => :catalina
    sha256 "e5720c6aa2eecd8589f172c942580885473246d1d3b5a19faa0e69a4908388fd" => :mojave
    sha256 "8af1f0284c027d8d0ba5099729e1cfa22326a15b3590823f0755961cc97e38e9" => :high_sierra
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

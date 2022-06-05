class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.0.4rust.tar.gz"
  sha256 "c8b82256e74091dc15570ccd1447259d27923cdb2eba16d26487b497518d33cc"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    chdir "rust" do
      system "make"
      system "cargo", "install", *std_cargo_args
      bin.install "target/release/cfonts"
    end
  end

  test do
    system bin/"cfonts", "--version"
    assert_match <<~EOS, shell_output("#{bin}/cfonts t")
      \n
      \ ████████╗
      \ ╚══██╔══╝
      \    ██║  \s
      \    ██║  \s
      \    ██║  \s
      \    ╚═╝  \s
      \n
    EOS
    assert_match "\n\ntest\n\n\n", shell_output("#{bin}/cfonts test -f console")
  end
end

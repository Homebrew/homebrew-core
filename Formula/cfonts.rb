class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.0.2rust.tar.gz"
  sha256 "b22ececd4e81f4dea1f3ea3a4e38df9788b035f8f02aa0afb510e80a6bc36006"
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
    assert_match "\n\n ████████╗\n ╚══██╔══╝\n    ██║   \n    ██║   \n    ██║   \n    ╚═╝   \n\n\n",
      shell_output("#{bin}/cfonts t")
    assert_match "\n\ntest\n\n\n", shell_output("#{bin}/cfonts test -f console")
  end
end

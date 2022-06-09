class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.0.4rust.tar.gz"
  sha256 "c8b82256e74091dc15570ccd1447259d27923cdb2eba16d26487b497518d33cc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69f920b8101381698c98ee2f8279bfbfdb60411e76a102517d1e9d1646a22fbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "909c675b070bf4dbbf13655e7263ce7e73b9c006431871e92cac79cb9126bcd0"
    sha256 cellar: :any_skip_relocation, monterey:       "b663353dc3812860984b98f0f422ad70ac3afeb332f3ec53f8ba7fe365b1f4c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3d77e41e913c73c751c50773f87e69555604e5b2ff5143f1261b905ef573c1e"
    sha256 cellar: :any_skip_relocation, catalina:       "e6a2c408945981bbd2095827fb7c4e7de1b995d1a7582be04256d9d8118455a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33dbebecbf017436acae02884df0708ceba60af94e782fd56957f060b0c00dad"
  end

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

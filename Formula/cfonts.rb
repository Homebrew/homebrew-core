class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.1.0rust.tar.gz"
  sha256 "45c40dfc867234efc5c5a2df687ccfc40a6702fa5a82f2380b555f9e755508e6"
  license "GPL-3.0-or-later"
  head "https://github.com/dominikwilkowski/cfonts.git", branch: "released"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]?rust$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0c159afb368d8b9e13fb37a74541565a42dd93b87bcd8c0da87db15a7badde2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1e69ea5ab21f9d023604f303a391ad62719983d4d149c7e93fd861bac3b2fac"
    sha256 cellar: :any_skip_relocation, monterey:       "f437c2cc028c51e771dda66e97615ac4d16a34e8a1c54946cd15cb6f08a0393b"
    sha256 cellar: :any_skip_relocation, big_sur:        "895ed126b72d7d98b02746f0740f7a59e6845186d12160bc9f971631982bec20"
    sha256 cellar: :any_skip_relocation, catalina:       "d4e904e4b54af0233a7d482b811d1d671613a813b6fef4ca1fbe1d5925cc2ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77d509e8ab022436a9c3877e63d08cc734b27ed1ddd99791f0416c96a415d913"
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

class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.1.2rust.tar.gz"
  sha256 "39e863eea0c16087ae5e289124f12ceaba9452939c04518ae8f82c28f0121200"
  license "GPL-3.0-or-later"
  head "https://github.com/dominikwilkowski/cfonts.git", branch: "released"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]?rust$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36c04978df055ae08b4864d55033773dfd81f73d27ec683815ee0f20a420f5e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb1d6471019040416b3bf478c5cbdeecee74bc27f338c350e8d00434bba29592"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2337a3e30821276afe9fe0a540826d473327cfe7d4fbdebe0acd7f4b41ec959"
    sha256 cellar: :any_skip_relocation, ventura:        "48a09335d873f511455b92a20429159a1c47d27fdb169a5e96122c3cda94a98a"
    sha256 cellar: :any_skip_relocation, monterey:       "9dad9f65821401be63d05299587e420ff798e30b3c51574f3cac5f5efa23cf8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "40ae326a290c7c5acb24160e90a747b25d324171f553160bdd0f2c64814b73d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f24016210d611fbe6250c40570ca4d33bd91113f37f1938496fece7874428566"
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
       ████████╗
       ╚══██╔══╝
          ██║  \s
          ██║  \s
          ██║  \s
          ╚═╝  \s
      \n
    EOS
    assert_match "\n\ntest\n\n\n", shell_output("#{bin}/cfonts test -f console")
  end
end

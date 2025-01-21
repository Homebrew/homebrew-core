class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.2.0rust.tar.gz"
  sha256 "8337423201558b43ae48e0749058a58623700cfb777288f3a520dcdb0d723a6f"
  license "GPL-3.0-or-later"
  head "https://github.com/dominikwilkowski/cfonts.git", branch: "released"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]?rust$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0820bec21514d04c1f5195a1cd072eb0bebde76762c6684938610253886122dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "378d7e5f0548372945a13f72f2caf4deafbf2a27bfb3d9b8f26bcc01bde8d52f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7844d07086770b7ff3d8103dfe7c150370b857cf3dcee5d6812fc34bdb350b4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a2d0be69dedd298b3217ca427c0dc2c429a911a82f847e4e37da811a0f20d43"
    sha256 cellar: :any_skip_relocation, sonoma:         "270fc6508128e7972125b2342f1b0da0d7d9af02dced036b4033b734aea0711a"
    sha256 cellar: :any_skip_relocation, ventura:        "3ac4832acea4e04ab4cf44fe47c07cbbadc961caef1320bbf5783e98b3be14da"
    sha256 cellar: :any_skip_relocation, monterey:       "a64c35cd812bb2118c8cb47a6f5c47b3fd0ccaf1cd26e7603feb7f050da0b260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4324fb2da4a6d701d32cf3ed3c2bda2e9e9508f17443edfd5252f55516e48325"
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

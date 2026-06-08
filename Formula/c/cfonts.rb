class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.3.0rust.tar.gz"
  sha256 "e9d4a5946242a42f34114cf3f0af077a89bf528adca64170749b4a4f9e2966a3"
  license "GPL-3.0-or-later"
  head "https://github.com/dominikwilkowski/cfonts.git", branch: "released"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]?rust$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f46ca452dd65aeaff877569858af6fa472cd5110e70f5e0aae8348424cdc9517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12145976d033447c9e14e635645be9ef4a4722217642249eb3cc599168cd882f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6520755bbccd53b9faf41915e310be59067bf36be7651f5025e6a9ec0e88ae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8308a8c123feed85a6026b36ea3cb135d4480efbdfabca638945f68cb59ca67b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa7c8429f052b8ce53015ccfcda717230dce8d7085bfd93a399b3a58c845f4da"
    sha256 cellar: :any_skip_relocation, ventura:       "14888787b2cbaf85dbfb0e64d82fefee14fe43ce3fc89506ed8099ec25e3b1ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa5ed6124f164c73452b19b8e7c04c9ed22286275adc2f34609f20cb8a243653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51801962e384e5762855f70db76503ecc871f1ea012fc6dae86d9e5ac2d3d11"
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

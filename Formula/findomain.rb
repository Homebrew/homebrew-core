class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/8.2.0.tar.gz"
  sha256 "ec795b7f044093eb36a3f74e89ce61a90d1411d509151871e2efcd5a6771888f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edb4bc814eaa17e7ef03bcc5193f8c212e2d32f6bf48023dfccfc930ed75d51f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cede679f611ecf2772ab3201e63d80464559f6ba0b69c3b3793a598c9dd6a83f"
    sha256 cellar: :any_skip_relocation, monterey:       "4db4d87053f1338ccd9d427d5469774a4d072677668277d1045c4b77524e1c9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddaffcf5c248ac23cb049de67e9bde3597bb434f4ae5d4f3b26e74111b10c988"
    sha256 cellar: :any_skip_relocation, catalina:       "f6148d7d971aa9060801511bbad96123c0bb97fd462243e2c5595f272ead307a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20e0910286731c19fb62a683c108c41b86132c3827753f2e9de8ab5f15da5b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end

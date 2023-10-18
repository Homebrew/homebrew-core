class Joshuto < Formula
  desc "Ranger-like terminal file manager written in Rust"
  homepage "https://github.com/kamiyaa/joshuto"
  url "https://github.com/kamiyaa/joshuto/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "14155a02cfeb0993a4906635a3c121589451e155e067d1c0d1673abdd1494ca8"
  license "LGPL-3.0-or-later"
  head "https://github.com/kamiyaa/joshuto.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6a4fcb749dfa80441c735b716138d8f616d4d5216d9e115ed18d5c0ad106505"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0fa5caad0bb515343b50a5b71284bac2ef80fa1e20d45e946c5de2827a57ac7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b03edb2446a540b08c27d2479f57adc879f1ed88ce0df4938a278a1bed6337b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7ed4e863b3abbee175c615e364e1fabbcaceb4965e31ff59bb950c41f1dc608"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b190d261e2cfd5f9a21a21bfa7316cc0468abd2c1e562c9030f553a4b17de59"
    sha256 cellar: :any_skip_relocation, ventura:        "623f1906e443bc94b46ffd9e45ddc33f1dc187facdac07b92a0ab34bebd956fe"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa2f3762feadd6fecb14d428696f1345cb44a33ca4a58201884dccfd084fd41"
    sha256 cellar: :any_skip_relocation, big_sur:        "51bd053858f7a35857b16c4c22584786a3e1664c71d663eaf18808e5290d4c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b3d66a76fd106b2419e14b5de5635ba3b1500956de864a765c837da471d62f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgetc.install Dir["config/*.toml"]
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    fork { exec bin/"joshuto", "--path", testpath }

    assert_match "joshuto-#{version}", shell_output(bin/"joshuto --version")
  end
end

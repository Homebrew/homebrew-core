class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.3.tar.gz"
  sha256 "ec967a094f4de76880072f83db830745d4b34ce8f41b14047d8158187ec14212"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79d2b1d6c4972d60ff0dd08e948b452b29bac1e4d9db0dd80a259fd3bf6a4860" => :big_sur
    sha256 "63d6a0d8c5839c93e61ce2caf6fbe912722fead979bcaaba42f1f9c066e7d6fd" => :catalina
    sha256 "340adb52b40c2722030adbc0698d528226b873956b2a65a66f1850b1435bde41" => :mojave
    sha256 "8a7153836445c301a9510bb9481d20d8cfb51b74c991f6c1e5b0ed23939d260a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end

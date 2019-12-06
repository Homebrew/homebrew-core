class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.4.0.tar.gz"
  sha256 "776468072b90b8cb68e063fe1e01be581a217b00bc68febeed19cb23a28d0e04"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f347e69919162e5abd4ee3f2e614527e1faa3cdcf2fe915e11b921b9c8a28b8" => :catalina
    sha256 "8ee48f0d0a24874e5e9f7f3244875612a2f68de5e226dac7f90a1dfdff3fb425" => :mojave
    sha256 "3ac1a5de0e26b07541ff87c24ffb62e1f04e5d5b1141d112ec8040569727c3ff" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"berglas"
  end

  test do
    assert_match "#{version}\n", shell_output("#{bin}/berglas --version 2>&1")
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end

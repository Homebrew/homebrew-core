class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.5.0.tar.gz"
  sha256 "10e0754b034ce84c5783e494ddb5772265bc8b1cfaa1a13871521881c869b4b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fa9dfc12fcb5341c8d3d5a6430823134c133a4ff59234ae06baceca4b7bc056" => :catalina
    sha256 "d3eeb994d85c737d1a1b5d47d198e67fa096bde3c5094bd34396292f08fd43f7" => :mojave
    sha256 "45096c7ccf9eca67bf048659df8e8b166d78142776d8e8ed981c5d32d7a152da" => :high_sierra
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

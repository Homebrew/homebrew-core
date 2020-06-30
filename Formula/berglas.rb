class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.5.3.tar.gz"
  sha256 "d85cf4b049346b8e643f0870c37c4ea7dee147f10c7f001c828071c13df2fa70"

  bottle do
    cellar :any_skip_relocation
    sha256 "e605a635dcf6f9382bfcad60c4dbd1711d2ea296687714a8e5ef9cccaa0a1706" => :catalina
    sha256 "a0bfb7a0cd89428b98e83dc4e1c123f54229ab81716596a8d7e9ebcc6306cf3f" => :mojave
    sha256 "45c5b05613c86447b61fe8538c09778754597cfa4d5f6284dcc2c60af5f72683" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", *std_go_args
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end

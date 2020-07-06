class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.5.3.tar.gz"
  sha256 "d85cf4b049346b8e643f0870c37c4ea7dee147f10c7f001c828071c13df2fa70"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d895f86692ef19159a769e2c30742f694ffbd54dbe272f58a9c755a097bbb3a8" => :catalina
    sha256 "56c43d970f6af85431a1a40b6c249de56c2e22f74c385919118351de749a4a7a" => :mojave
    sha256 "cde26510e8ea539500c5b76a3b7130a4f29d03c1776eb36e4e1043f065f52dbb" => :high_sierra
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

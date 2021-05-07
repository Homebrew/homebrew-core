class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.182.0.tar.gz"
  sha256 "8c91b6d03e1898f7664376e10a3401c39c5b280f7d0d3e2f4b6a742564f0005a"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1ecf271a771195c05ac549d1474b6fb3d1f5329ffc5d53699fe2e3ff3e054096"
    sha256 cellar: :any, big_sur:       "14ee1e65ea26c44f8cf9d0c918a7b97b153e0efa4f150d53f053112a98475c0a"
    sha256 cellar: :any, catalina:      "ee3d299173558daa567f3cdabe0ffd4341db9f4763890c7d44395c9c7d2570a5"
    sha256 cellar: :any, mojave:        "8c309a19cb14cef2168e843c24041810d018feb01c3d43fea3b5bc9d2b057616"
  end

  depends_on "ruby@2.7"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby@2.7"].opt_bin}:#{libexec}/bin:$PATH"
      export FASTLANE_INSTALLED_VIA_HOMEBREW="true"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod "+x", bin/"fastlane"
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end

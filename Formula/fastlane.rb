class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.174.0.tar.gz"
  sha256 "305036b90a71d6cc32b6b1dacc3d47bcc928165f2fae867a20b2a1396fe21cba"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "12bc641796cffbea9bc74e3dce158093428a6ea0a36f7439493be7feeb5460c6"
    sha256 cellar: :any, big_sur:       "62fdc174a4b5383f1b132290ca237e4c4a622ef63b8feb1f48e05a8196c141ad"
    sha256 cellar: :any, catalina:      "50ed8cb3f06193191389573b0d4450b6fcbabadaa1f221b0f10057337069a774"
    sha256 cellar: :any, mojave:        "5fc057ce1736019e54d2a78b25a576c7fde22fa01a122f7c7a1bd773ef415fb7"
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.177.0.tar.gz"
  sha256 "d82a435de34333c385cbe63c9fa36e3ff88ed6030147651fd928945342c4f1bf"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "50fa19fcdfb47169d3d692827283b048074588f2d51d1dd0f2d86153162d1243"
    sha256 cellar: :any, big_sur:       "1d3b87229fefe94ddbd9d9860bcf2af41dced3db9e715ad8d1324f9108d6d2f0"
    sha256 cellar: :any, catalina:      "ac5e76f63a527770964a6c11dce39fe959dc864304c08ece8d7eee3fd9d6ec54"
    sha256 cellar: :any, mojave:        "1392efa64011706ca7010190139ddf8c9407ddba6180b74272416ee84499d847"
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

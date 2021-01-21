class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.172.0.tar.gz"
  sha256 "09653f41f43814dbfb58d0d7e82a3b49a550d404fa6d4f37f23b4d110dfc0859"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "639151714c232ce3e6e3f3597b8d7068fd4c78fcd6ca9baa3437eb5d6373a239" => :big_sur
    sha256 "32b03b5c1a555097fc9a2a66385fa3f76f4c4fff01ef670399114b71801bb449" => :arm64_big_sur
    sha256 "e9d180f14840a0498e43492f384bb63237af3cc99e9597f36b723fead035227f" => :catalina
    sha256 "c783f67bb0a3f2beb6c32bd24efc3c579d89e211845e537980094ccfcbf1680a" => :mojave
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

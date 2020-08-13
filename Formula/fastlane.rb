class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.156.1.tar.gz"
  sha256 "d25648a8b59dc3c0f40cbb3afefce9b0bad9fb6b3b5884b3b5e05c792cd63982"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "85912077664d63678113c35fa72ed194825913775b2ed8edc8e9c636ed9273f5" => :catalina
    sha256 "d525a79d67d0b6a2f349d96fb99af4577544667fe87dd0f7505edfd70ef5577d" => :mojave
    sha256 "7e7132784e99338bdaea8e21ee9cadca7cbfd46a8ba4ee876e3b8afd0c7835d0" => :high_sierra
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH"
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

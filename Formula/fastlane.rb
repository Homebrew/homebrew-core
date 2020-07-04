class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.150.2.tar.gz"
  sha256 "41f1c05e358e8fb1ce3916a987551d3bf84edade099a2b7d886fb0df309c3288"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "5b7ce6bc959e40815166ffaf9a3629fd4b889ffb4db1bdc43dd73243b72588dd" => :catalina
    sha256 "dc07fdd07858bc53a9876834f9705e1587a8b647f6f6f5d490106431640d972a" => :mojave
    sha256 "42b642eef2983a8b09fd1dbf54c98c72e725ddff5b1591907eae76c38ca075c6" => :high_sierra
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.148.1.tar.gz"
  sha256 "71e32bd52171e315a4b23c89a47e8ffd5b31466b3c9f10d858c1b38b6276d532"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "7a70d265eaec5174a8ec9fb04faf9493283e88f0cb02dd6e9c76350a37f5b56d" => :catalina
    sha256 "976300b6ad99a3d89659416c76957d91a95e1bf0ec11b6af5244150ad34adb8e" => :mojave
    sha256 "499092758b722b61ce37483bcbd0e0eb6dd0254a75dd4b0dbea73cd8657e5cdc" => :high_sierra
  end

  depends_on "ruby@2.5"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby@2.5"].opt_bin}:#{libexec}/bin:$PATH"
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

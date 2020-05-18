class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.148.1.tar.gz"
  sha256 "71e32bd52171e315a4b23c89a47e8ffd5b31466b3c9f10d858c1b38b6276d532"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "c68693868a932139b87ccffde7ed75e4ebdff230be142c5eb3721ebfc947a27e" => :catalina
    sha256 "57cc9b4bb5500b645360f8c4dd9716fbe6ed9850fff314c77fc07f66bec4ee49" => :mojave
    sha256 "914e59b23c028bf718f69e8a9634811c824602eb962c060bcfa9abbb0e695442" => :high_sierra
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

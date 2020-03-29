class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.144.0.tar.gz"
  sha256 "4fefb6b4763369284bf5bad93d0d9fced211614b46ea11ed9b30e852a7f5bc23"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "76db53b447965db8d38fe5ced4d99e6a927adea1eefa5bba46d3c35988fc30b6" => :catalina
    sha256 "8d81c8b1f471c440b3eae8a3005d3eacbeef22640224d952130ff20f72555717" => :mojave
    sha256 "d56a45d142843e6525391f9be6b18e586e4345ba36cc909ea88cf07f46da4486" => :high_sierra
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.138.0.tar.gz"
  sha256 "81ee26356de1357b76120aee4d13dd789dd3e358115d830ca2030d4060b0cabf"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "08561ed492512bcd54d6fef2f99374ac7728508a285ee091eacf3047384a5147" => :catalina
    sha256 "43ba9f8d8af2e6b4dd55c42bc23ab992950249ac0c39bf6b89785e483a1f0d4c" => :mojave
    sha256 "ed73eca559ed8d92ce1a08689826b45abb904fa07d3b3bfc0cf6db81386b0c90" => :high_sierra
  end

  depends_on "ruby@2.5"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby@2.5"].opt_bin}:$PATH}"
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.138.0.tar.gz"
  sha256 "81ee26356de1357b76120aee4d13dd789dd3e358115d830ca2030d4060b0cabf"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "c414c82e8ef8faea360ce8c11d2fe1825be5ccf1375a1ad02cfb752a71df760b" => :catalina
    sha256 "c27022677aa9e1699267d33de5bdcc1e3ba293a2b2b17efb7a35bfabf8f37f26" => :mojave
    sha256 "c3828a4af9506b930cfb99765581474cbbc858cc132d9900a771fd2b80ca1fb7" => :high_sierra
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

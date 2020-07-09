class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.151.2.tar.gz"
  sha256 "476b03ba4245c8ab2b2589fdc2ac92d8437b9fe8fa4f70f42a549063035eae8c"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "c076ed3bf3a53cd064c35c724f213d7ba655fb4bd400f27abc9f25f35849f38a" => :catalina
    sha256 "abbc74cb0e3e68f88a0786f56b49bc34089ef13d9e70a4ddbd437c17d32087b2" => :mojave
    sha256 "07ce9e0137988aca7606982eca19326b0142d83878256f428b5762e2abfbb33a" => :high_sierra
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

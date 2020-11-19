class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.168.0.tar.gz"
  sha256 "d3b09b502d269325966c3996b9ec92a433adbef3f139efcd66beb3a8778d5f21"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "be8145485326d9a3c9b398743872e5c85c29d957198f28ae0d63c9813483cc8b" => :big_sur
    sha256 "7d33a30c1e854a934a725139ea60eb506a2b0fd4965cccb1947e12652974ec38" => :catalina
    sha256 "34fd983b5f9522389d76e4d4d1e09092ff6f36df7e1b11c6eba756a26570820d" => :mojave
    sha256 "6dc02f7408f8da0982f977dfdb0e6d3296d8356d97e7c5cf17b59ecca735160b" => :high_sierra
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

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
    sha256 "1487fffd2cf5252bd85c52c6a933e3da4eb1a8c44ca486a3079725b3548ae0ee" => :big_sur
    sha256 "737a7ad686ecd86977e629e61e001e82b4d9b772468a345254a66d6903eb3244" => :catalina
    sha256 "973157160e8e5aaa0fc9881d4fdf1e7c80cc9988409fe00ba8f89c006777f12c" => :mojave
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

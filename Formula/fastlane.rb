class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.180.1.tar.gz"
  sha256 "244323e068e35092a7cf40b4e461ed2cd97b2bc42122e47f5410ce0fd04dd995"
  license "MIT"
  revision 1
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0ebef11885e9d42706f3a7eaf67d64b4ee2dbf410f3e7cd16c37c55040c90d82"
    sha256 cellar: :any, big_sur:       "142d0d96c909b4d5e3d72a8195409237a41e09e1b160b79f2abc47f99230e635"
    sha256 cellar: :any, catalina:      "b80f4590f99c5e04846a922962c49552233699a8339f8c4dac6ca5f852464633"
    sha256 cellar: :any, mojave:        "73aaa47abe9c23fe4918c4a210fa89c2e3686449d4fbf9d0fc863c40c0ff1bc2"
  end

  depends_on "ruby@2.7"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby@2.7"].opt_bin}:#{libexec}/bin:$PATH"
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

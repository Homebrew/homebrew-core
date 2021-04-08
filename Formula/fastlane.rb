class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.180.1.tar.gz"
  sha256 "244323e068e35092a7cf40b4e461ed2cd97b2bc42122e47f5410ce0fd04dd995"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4297d2444c76a61cba3f4a938bac8044d4d32eb5ecbea34b3c3ac6c91f667b7f"
    sha256 cellar: :any, big_sur:       "848bc8072a07ba1f02ed513f7e5e33a85c9d074c96fd345abb3390c00258660c"
    sha256 cellar: :any, catalina:      "150fc65c16a5946c2709f145ff40e51e0b5deeec5bf75ada50078ea76fb7f014"
    sha256 cellar: :any, mojave:        "42425e2bd0d5322fee4ec9e788bf12822e82c677bb3989cdb48bb004020c588e"
  end

  # Issue with Ruby 2.7 not finding gems correctly
  # https://github.com/fastlane/fastlane/issues/18517
  depends_on "ruby@2.6"

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

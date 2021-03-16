class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.178.0.tar.gz"
  sha256 "050afeea60f292d3bb83c56089f97d130ca0283fe87a7defb31595d9344557c6"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1a643aa7391ff8c1d9fa6b97bf545ff05af193c38a1b183626e44ca4ae9b5623"
    sha256 cellar: :any, big_sur:       "124a505b804339f84a36ed6719055e0d44f00640f127dfca741dd1f264a8e0e1"
    sha256 cellar: :any, catalina:      "f91683672542fc19c0942e64115380437232333a3473f77638941f6b20c24ec0"
    sha256 cellar: :any, mojave:        "8ee527f7f51693df5312c93aebff9d63531b1a17be755a0012b9ea22fdd33cf0"
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

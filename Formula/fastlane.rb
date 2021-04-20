class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.181.0.tar.gz"
  sha256 "b21a5a2b1cb62a3b45d0857538eab0c5d43be1962a7955b97250d805694a1a07"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d4f3b88c826728eea39323c9304e4dbced0c5a003332794655bfda8602922e0a"
    sha256 cellar: :any, big_sur:       "e95253fd57db3a26fb0335c378390110319e81d45117d1d50452f9f2c01fc13a"
    sha256 cellar: :any, catalina:      "cac86c45e251704904bc44cce38e92e9b10c47079b5da667ad6b85dd092e44d4"
    sha256 cellar: :any, mojave:        "b5162230697b6697d868e6038db124c83d8e4b938fff560d5ea2800f0c96efc7"
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

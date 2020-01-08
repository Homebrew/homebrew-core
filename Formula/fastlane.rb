class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.139.0.tar.gz"
  sha256 "b90b7ff47b8b9404eb8c18c7832409fb09b42b49e864e2534c9d6e071e763b5c"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "427bfcc632f7466ea2f88aafd779c22a8fc4cdaa22a9943bf1c1be4252a94162" => :catalina
    sha256 "1459953a4d6f1fc30c01b2d0f44f9979cd6c82497c6f0726f254683c1e391d1d" => :mojave
    sha256 "fbfc1f1732164f87d35f20d1dc1ef2b156465c28126fa81ea44874c522a73f4e" => :high_sierra
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

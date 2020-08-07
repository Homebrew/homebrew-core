class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.155.1.tar.gz"
  sha256 "9d167ebf07993beab61ae7ed1f2af83032abb102d34e226d876de5a046508cb0"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "4743e025e75b4855f477c4ea844bd901d392123cb8bc67753c20d52dc5ae35c5" => :catalina
    sha256 "3cc2fcd0d71b7127dca2e35c311b87435254c3ec3154693983109d29c67c6c74" => :mojave
    sha256 "7ba41cb5b0c245260dc977e8d4194b42589151de724feae5bf913cce806d14c2" => :high_sierra
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

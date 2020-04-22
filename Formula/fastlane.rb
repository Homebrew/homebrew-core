class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.146.0.tar.gz"
  sha256 "20d4ccb91e2c20e3f0a080c408c90b941ad55e107e3577c3f9e0a0a77b995eaa"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "fb8c1c3ed5112134df9f551b86028543be018fc27f94349f1790c5b066bc0813" => :catalina
    sha256 "bfd4cdb093ae3b93ddca5d3f68adf8049ae1131e0654764ca70ff43cadff1b92" => :mojave
    sha256 "fa6b7683b5af8e2199b789ac2678a35fbdf6ffa5bb9d4d35346313138386025f" => :high_sierra
  end

  depends_on "ruby@2.5"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby@2.5"].opt_bin}:#{libexec}/bin:$PATH"
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

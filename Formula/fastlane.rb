class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.150.0.tar.gz"
  sha256 "b3950acf2da0bce0bfd4229f3cbf30aec2d5059fd937b4a21083a3190af8efc3"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "4bddf85fb7ccec66eaa235990df2fee36ea95cfcf409b74fd03d4361ff237f58" => :catalina
    sha256 "11adcc526b8488c0f9f94f043617ab27cf02caf32e81da261c9ba2a65a378063" => :mojave
    sha256 "38fcd34fbe5497c1ddd350536ce06371a15a40eade20d5e82a9716b8acd2bb04" => :high_sierra
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

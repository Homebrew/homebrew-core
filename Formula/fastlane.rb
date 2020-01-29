class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.141.0.tar.gz"
  sha256 "18b81899aedf2591a883ae96ab3722664bfba5a855472d82ce43b57eb9811bd6"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "1b5de425745039cb47e396fe85a6a9b4910317c2abdc3fa64c0b58d5dd990671" => :catalina
    sha256 "486f064585ca683ea4a8bf388a704d6e3c673c19f58200049ff7d7e684c4be2e" => :mojave
    sha256 "1e0eac14d05a0fa00c7fa5e3fbbae8bd4fc56ad74e1f9caa28e4fb45cda191f2" => :high_sierra
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

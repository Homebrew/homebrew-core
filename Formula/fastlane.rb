class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.150.3.tar.gz"
  sha256 "469ceba4b7a78e39a9ef96b91b221a8cd7f55ed231276c8b41265a4a32f010be"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "30c11fa82bf1f658415e381af0f4f703f34934e2ea72f99c7cc0e89f746d5f48" => :catalina
    sha256 "0de49f8fd0e93564b238562b5df5ac286f7c8be9b215cfc062cc784a5a034919" => :mojave
    sha256 "d709cf4cbd0fe850a4e4cfffc578cfe9138d378bb750dbcbd204b43ebf189388" => :high_sierra
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

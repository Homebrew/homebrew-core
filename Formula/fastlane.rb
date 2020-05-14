class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.148.0.tar.gz"
  sha256 "502304b212b3bccc67aedc50fdeefc6780902f410886cd5f90ac0c5cb8f7edad"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "9bd6c57154394e1ce8f30718d4a9b462ddc9838130a27632cf81ce549781030e" => :catalina
    sha256 "2b442162852ff2800e7ee5479f70c930767a795ea5f0dd122890f11c1da1aaa7" => :mojave
    sha256 "8520662ec6453f88e1fdfaae5c150236b5792261d0e013739e3a26eda3574b5d" => :high_sierra
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

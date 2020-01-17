class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.140.0.tar.gz"
  sha256 "06f6c3f348d1892d53ffc2055293b1d7fe0898c43e183811bce6055da8536be6"
  revision 1
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "3ac5d449574b304dda19bb1e2b5738e4c2f8912884d57148b590f5d8868f6924" => :catalina
    sha256 "fa934f12bae8f5b7a288ede5e71d67a121f6ff83f0de8fc9720b7db6410876b8" => :mojave
    sha256 "2fe8e04488700c5db78892802f85bf3a34adf18e0e17fc1a9c7a7b05297932f1" => :high_sierra
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

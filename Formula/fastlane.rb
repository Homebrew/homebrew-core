class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.150.0.tar.gz"
  sha256 "b3950acf2da0bce0bfd4229f3cbf30aec2d5059fd937b4a21083a3190af8efc3"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "0a512aad98ed6fd10f0329b07e3cf176d6cedf8ed2a2b43497d4a281170a5a7a" => :catalina
    sha256 "e99bb90e16debcd1d70a65433874a0ef9d0efc922a98bd795ab1e010825a0acf" => :mojave
    sha256 "ca383abdaa0a51ad126fe1eb92c5d77310d298c359fe73f6a4730cdbd3582a39" => :high_sierra
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

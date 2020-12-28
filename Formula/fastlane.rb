class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.170.0.tar.gz"
  sha256 "d3b2f592b01e565d6fcb37199ad1efeb97f1879751995d676b0d66c7b78e1a43"
  license "MIT"
  revision 2
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "1555f75d00ccaa0a2b06da7252d56ba3ec72787ab187ef417b1a0609e6420861" => :big_sur
    sha256 "cf8b0cd387ed2fe15bbd7a1741dac5bc668e60e1b568a206de2a11fccb6d2d9a" => :arm64_big_sur
    sha256 "65b5ea3eb883f38a6ec7a4cb1fcc71452116c1a8f939af7a766bc30016590183" => :catalina
    sha256 "7803913c4ec30f8e4daaa0821e4bde930ba04a1d558f78b5b18176224df68c9a" => :mojave
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

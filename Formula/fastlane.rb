class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.171.0.tar.gz"
  sha256 "5805535092c98e8cddb768b05ced0adf6751774ea891d45461da3623f7780a24"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "9a55603c79fbe6fec2daed4678096a0ec4f46ac510bf80cb600eba9d2f47f48e" => :big_sur
    sha256 "8351fce8024aad9c54a61e5c0c6d06d5e11d864b4707ecc0999b6c947a698876" => :arm64_big_sur
    sha256 "5f233a06e1e8ebcf6202fcf85b63e29082bb9943a956f993a15038efe607be71" => :catalina
    sha256 "1aac3d9d5aa09f7e68ba63c577bf8817984034ba2f8f11788ed91f02d035acda" => :mojave
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

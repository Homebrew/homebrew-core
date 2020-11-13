class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.167.0.tar.gz"
  sha256 "d46fefa9705073762fc68ea7ac92e0b7dda8feaa32efec9f0530ab0935a8ab0e"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "551a8a4744e19e2f34bdcfff8a4a07db7fff7ed1fce544deb4b39333f2fc1cbd" => :catalina
    sha256 "5c1e3b32733c6906d6b49e752b582c8747b965f5d6ea8434ae85dbcce6ece018" => :mojave
    sha256 "55882f586ab1cba149ef7fa793653a87b90a8efabf2cc687c91aa5f0f048232b" => :high_sierra
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

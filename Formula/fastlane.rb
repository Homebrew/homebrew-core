class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.164.0.tar.gz"
  sha256 "4f00f017a2dc6bc2500a59851b9be4893b25c497bf4af1b9d5f46a5edbea37c9"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "8e335dbdd786ba2b12220474ebd4c3bc3d6131b87bb58e68bcab558d1e980412" => :catalina
    sha256 "30f7ae697cf99f74b3e322bfd21f8c157d98b63edf9b134cd07894439e4537ac" => :mojave
    sha256 "9a5bbc4913582b65bb52d032a21220614c9d77490207e9877850d6694f169a95" => :high_sierra
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

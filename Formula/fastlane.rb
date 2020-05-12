class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.147.0.tar.gz"
  sha256 "62838e47bcfd1f0679998ef86c4c3437c70a437c2d744b8888338c306d3ab763"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "bdea7bda26041b39f24a0671e939f62ea960813c710784c84feaf97866a65a7f" => :catalina
    sha256 "9aa03c3b825af2dab6c378961e46c637cfc89f4e719d7043d0463ca26691990f" => :mojave
    sha256 "76d977f241bc2f2b38131801d5def655b1bcdfbc633d1d2f0246567d37e8c10e" => :high_sierra
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

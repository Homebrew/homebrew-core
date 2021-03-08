class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.177.0.tar.gz"
  sha256 "d82a435de34333c385cbe63c9fa36e3ff88ed6030147651fd928945342c4f1bf"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "71c3d76952314627a7d08bc2239314d3d1649b3079d8858b2da916402bda2a9a"
    sha256 cellar: :any, big_sur:       "ca135fe59180785254545addf34ca887961c16664c5a5b735a87f525d22fa7ed"
    sha256 cellar: :any, catalina:      "0e67dd9aab27c07e06d33e5547cafa74e74d13806cd9411f16c00a6061e62455"
    sha256 cellar: :any, mojave:        "b425cee27fc586de4df0e84cc060e9fb4eb1c3181dbd32f71ba9213a39024c82"
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

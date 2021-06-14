class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.185.1.tar.gz"
  sha256 "3080c85306a436b113644a04dce821809ad79779f32adf603e2d779ab6be1d5c"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b51316b523d8a04b28708e99df536a21b8ad28c3b470e27208369e3fa4d385e6"
    sha256 cellar: :any, big_sur:       "dac134a7cb24fd8f96d9d9e155c588682e6bed78d88af25f8cbbc52bb9a95ac8"
    sha256 cellar: :any, catalina:      "e697f3784c18e7085afb90f53da73fd444ce964478e022e29a683ce92d6a6744"
    sha256 cellar: :any, mojave:        "da3fa9500aa579067e895b3c62f9772c2fa94b7dc5086e75507c64f979d5090a"
  end

  depends_on "ruby@2.7"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby@2.7"].opt_bin}:#{libexec}/bin:$PATH",
      FASTLANE_INSTALLED_VIA_HOMEBREW: "true",
      GEM_HOME:                        libexec.to_s,
      GEM_PATH:                        libexec.to_s
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

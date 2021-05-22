class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.184.0.tar.gz"
  sha256 "9b987e918f101bc590f41f61d92d7bc3ce51c60c40ad80e615c83dec9b100c2e"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7d31cf2ae80a8db7299b1d5216b4a8cda07241fc02e0206b559d0852951c3dc0"
    sha256 cellar: :any, big_sur:       "ff11047cae3f4f341aa3e57f9b241d5449109af39e54c027a80e8bdb1909eeda"
    sha256 cellar: :any, catalina:      "5bb57860963ffebd92f43a66d0e519f0163e340af5d4268f05f059f75208c842"
    sha256 cellar: :any, mojave:        "5e3aad1aafe224a0732dd27f56e6fd25b8ae1055a7a7f43f1a67179170f887f9"
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

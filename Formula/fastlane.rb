class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.186.0.tar.gz"
  sha256 "a48dedb569e250dd5509e118aafb3487ff78eea0ef99cc3d5c3615090590e01d"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "066e001f1107817426dbffd95fa74b7f5faa926b320e73df95896d926affa5d2"
    sha256 cellar: :any, big_sur:       "8018d19796871de80db717d883d84d45dfc6dda266337b651185d872679d2ec7"
    sha256 cellar: :any, catalina:      "de294a150a0db258b7e9eeb942f6a8d7a4f7efaff88f8e2dd8130a2b904aa87d"
    sha256 cellar: :any, mojave:        "290985ea0d996d3c320850897f06eef311882cf20af7500dada5fd938e6121e7"
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

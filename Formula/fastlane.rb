class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.185.0.tar.gz"
  sha256 "dc57213fd7e63cd48487acedfd4064dd34d845abc0b3d4e4f0866fc815b9e7ca"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "30590f8618c9c2364cf99de64c8c90c9c70456b175be867628289daac539bc39"
    sha256 cellar: :any, big_sur:       "341b394ee0cdaa5e5456b66fac2c5ecdcbc4d44933ba3d9fe3b1905a77d89c80"
    sha256 cellar: :any, catalina:      "8c564ca18df06f2c39d06fcef454feb36e8f9dd3c7c7accdd94cad2f9601ef90"
    sha256 cellar: :any, mojave:        "051e4be67cc5af26725c03a4fb1685c8a249bd7680b1ecaff77da6c46e3f8676"
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

class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.183.1.tar.gz"
  sha256 "330aadd2fcfafa7fc6a56bf8fbf89db6e7160d6610dcf34fc0a464c1c64a28a4"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "70b4fb5330701f9a28f32ddd841a17d7af1fcaa4e73bc10f48a528c715055ad5"
    sha256 cellar: :any, big_sur:       "13ae99292b4a3a2e36ab9467a46648f5acf269e222bf63f83118ec98ac12f306"
    sha256 cellar: :any, catalina:      "0fe947f48bc31ce244917d4a0b795d614e323e1b601ccfc2c2bd306b9b89e4af"
    sha256 cellar: :any, mojave:        "71dbb8cb765d871b7e9dc5242ec822ac2cd9cca2ddb3e99b4a03bc093a74bba9"
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

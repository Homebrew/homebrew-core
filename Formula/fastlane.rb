class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.184.1.tar.gz"
  sha256 "2711ff7f067523a9d27771df620ff0cf02e4cb0931741c11537b223e387549c5"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f3a7e474a92dfbad3edf3e8644bfd59892e0fd0560cee8b46a53a36057cca243"
    sha256 cellar: :any, big_sur:       "cd1fb40cf3011d9de1e67bda2d0010f4451fb65703ed0caf421b38d4cc62aeb9"
    sha256 cellar: :any, catalina:      "3ded77138f02471212781cabaf926961d43da9dae3591f8f7de35a7a81e5a9fe"
    sha256 cellar: :any, mojave:        "0cbe1320e5eaa9040b1c5bfcbafec05d98d93d074e555a5866544b5200b0dfda"
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

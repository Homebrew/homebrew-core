class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.189.0.tar.gz"
  sha256 "ad3cf267c098be640f1912b86c37ed7dc3ea5a3d58470eb75b05ca28aef91f32"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f9d9bd04ef5843689fbd02cc033ef0ac4aa56e48e856a98ea042eb52422ca227"
    sha256 cellar: :any,                 big_sur:       "2ba602f290f9a5bddc949e4014e3d4fd7ffa75157a0e143848da90cfa7824aad"
    sha256 cellar: :any,                 catalina:      "9d4342d347d40a30ed5dd5a99b9f142671e0163416094a8fd831e6965034297b"
    sha256 cellar: :any,                 mojave:        "d72d89a1b7a3e79cd18792c884df30b7ecfaa7123fb729f43a262f5b8d039fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d32aaa50bc711935ce4c56ebcbe67bad190ddcb4403c01bce4cf797ffd1d725"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write_env_script libexec/"bin/fastlane",
      PATH:                            "#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH",
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

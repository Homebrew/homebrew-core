class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.187.0.tar.gz"
  sha256 "142f693fe83db83d78f48ecc86301c55a2eb6e65628290508886326e390da4ae"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "afe92da42b518f37030df336e6ca7905e7617acca4b21d974f67eb3c58010c9a"
    sha256 cellar: :any, big_sur:       "5ecd9b3a8b7e6092dbc65bc2602e472083b6130cc60a86ca1c06d21d93facd77"
    sha256 cellar: :any, catalina:      "a3aad53e4004a89ae3b746b8fe0a88e43569203ecd79992dd4a460b0b3371433"
    sha256 cellar: :any, mojave:        "0ecf7c41c87c51f87cdce4643a30ece2d5ee128619779d6b13189430430a28b3"
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

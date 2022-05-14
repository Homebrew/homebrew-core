class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/1.0.3.tar.gz"
  sha256 "1922ba78d40efa08b6f79ccb8d74b2f859ec39a5c37622a7d1ecbb3ba50cff6a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2c0d97645e6c5f84d99728d4453d63e5b018a8d0c77f2df40d811466f8eaf32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6862be0cd39d91775f3336d40da31d7e7f6f645e767e77efbbf132a6b25f9955"
    sha256 cellar: :any_skip_relocation, monterey:       "352c72e737d04798510b4c7f739f13b3887f9e190836a8db44f7d382c1e75e77"
    sha256 cellar: :any_skip_relocation, big_sur:        "115f97b8ad4c7242c0baa1ec4990024c6984b758febf7109e9831a6ddd25fe5b"
    sha256 cellar: :any_skip_relocation, catalina:       "d56030780813971500593d4ccf3d672da95fc69655c432107a378877d9e2a38e"
    sha256 cellar: :any_skip_relocation, mojave:         "3d65153cae182cf1d98625bda798c191d348ff22a32f6992bcec0a6de5df4d0f"
  end

  depends_on xcode: ["11.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "SYMROOT=build"
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 2)
  end
end

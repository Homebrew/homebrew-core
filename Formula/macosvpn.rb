class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.5.tar.gz"
  sha256 "a1ab4276d22d42430ae8696420a9e0641609bad442036e4e2403d722a1d919a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3265e0c3da8a09a691f6cff3b8408184c7423ed49d90a7b2b2290b3b3674d99" => :mojave
    sha256 "478bec17d2000763fde198848b85478aa8ece4414499a1cfc2dd8925071f15e9" => :high_sierra
    sha256 "fd31b7b30a4867a7693a35ce96a6d74034e160f8b7cae1bc37e8ca5083552a04" => :sierra
    sha256 "4cf716851d7a1fda3ed5387504d01d8832b53f54fd7b683267af29fc5d18f7a1" => :el_capitan
  end

  depends_on :xcode => ["7.3", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 10)
  end
end

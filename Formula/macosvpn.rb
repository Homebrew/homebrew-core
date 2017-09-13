class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.2.tar.gz"
  sha256 "6dd50f13e0ed5efc597f46e14e57bf5dd1f6a1a93e431291e69da3b1ee9a047a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b29fedddab5f6768c12316f16daaf46f927c17c944be2280318bf209af04ebe1" => :sierra
    sha256 "4e4d21b1daa189ddfe03c94a2dce0a54f46ed524c706bc1f376921ee5707f9cf" => :el_capitan
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

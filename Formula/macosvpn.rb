class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.3.tar.gz"
  sha256 "2ef6928fd75d7e4e298d620c6250015597865fc7f0ed95b925ff3f2a8b2514dc"

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

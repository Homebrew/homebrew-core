class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.0.tar.gz"
  sha256 "26fb049820f5fa63226609753d1ee2944e702c32e21230586659a1198091d7eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2d16daa3ef23c14f2db4320b4a9c1450ad7aa30563c330e7119a4584847edac" => :el_capitan
  end

  depends_on xcode: ["7.3", :build]

  def install
    xcodebuild
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 98)
  end
end

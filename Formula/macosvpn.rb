class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.2.1.tar.gz"
  sha256 "95a61d1f324a6578cd7a2e563ec6bea983f7e516402308c6eafef756c6e6db24"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2d16daa3ef23c14f2db4320b4a9c1450ad7aa30563c330e7119a4584847edac" => :el_capitan
  end

  depends_on :xcode => ["7.3", :build]

  def install
    xcodebuild
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 98)
  end
end

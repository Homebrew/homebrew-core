class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.2.1.tar.gz"
  sha256 "95a61d1f324a6578cd7a2e563ec6bea983f7e516402308c6eafef756c6e6db24"

  bottle do
    cellar :any_skip_relocation
    sha256 "9951258df34bcc9de51e72deda6d3e0c1b8a8a0b5ec1b8a87fbae2e4ea7e6967" => :el_capitan
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

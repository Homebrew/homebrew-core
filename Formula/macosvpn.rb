class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.2.tar.gz"
  sha256 "6dd50f13e0ed5efc597f46e14e57bf5dd1f6a1a93e431291e69da3b1ee9a047a"

  bottle do
    cellar :any_skip_relocation
    sha256 "11aa304e24dc3e19eb89ff26f189bab1578cee1933c5b6b00fe3896f00965e4b" => :sierra
    sha256 "109f819b6fc201fa9b6244bca123a0c025bd6365f3e1a0917059bb504ed24fbf" => :el_capitan
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

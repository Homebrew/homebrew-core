class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/0.3.1.tar.gz"
  sha256 "b0bb49c9bdbaf678f6017f5be14abffaf12b7dbcc8174e12b3e15e3ef04c17a3"

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

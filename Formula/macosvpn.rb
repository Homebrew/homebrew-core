class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/1.0.2.tar.gz"
  sha256 "bcc1ddb7714c1c0030f1cf97c581dd03b30b189ffc33fd1f805dd9d0bd3e0363"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c9ee75909444d54b186d2318bcc18f9b85fab80b827d69565635e8ba09b3c58" => :catalina
    sha256 "f6ecbd3448ed2465b0362d42c6dc61e2c37cfd1f0d83bf57436c88d767add73b" => :mojave
  end

  depends_on :xcode => ["11.1", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 2)
  end
end

class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/1.0.2.tar.gz"
  sha256 "bcc1ddb7714c1c0030f1cf97c581dd03b30b189ffc33fd1f805dd9d0bd3e0363"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a2d3103fe6c5c674b9180af8c1c0e15e0583874a3986e84ac3a29cc76227329" => :catalina
    sha256 "e31d705b812175220fef63839c6310ae3ee28e2e8d61dc04bdb2972dd970f513" => :mojave
  end

  depends_on xcode: ["11.1", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 2)
  end
end

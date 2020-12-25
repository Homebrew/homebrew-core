class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/1.0.3.tar.gz"
  sha256 "1922ba78d40efa08b6f79ccb8d74b2f859ec39a5c37622a7d1ecbb3ba50cff6a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7b19c777696fa4283b7d7193f933fc5fd51aad0535b811586da4cfd3a528abdc" => :big_sur
    sha256 "36bd9094a1971fa5dd36d8968d7dc29309c1e0e735a5b5dc2456aa3c2adf2e52" => :arm64_big_sur
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

class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.9.0.tar.gz"
  sha256 "cbd66abe0c4044b0d62095e340abf3e63925d4380e0dce710a550764a1f62352"
  license "MIT"
  head "https://github.com/toy/blueutil.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adcb4a19c564cbd895f7e216df0a3293e17a009b243f5710edb9ba60965231db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e29ddccdf7253406a3685f4099f3424ffb6d399ff2643f2d79f281ad97b93a67"
    sha256 cellar: :any_skip_relocation, monterey:       "bdcffcaabd1270881f5b28da53aa1a6a28b93cbeb134d2b08891861653364b92"
    sha256 cellar: :any_skip_relocation, big_sur:        "429703e2bae1445d2a6ae2e1f52ed2c1f0bad3a94e80b44bfe36e698ba5ded30"
    sha256 cellar: :any_skip_relocation, catalina:       "3717d1a6753d4d94c4b4cbc92afa8ce58ed02bc1435806646fba4c7c1d04787a"
    sha256 cellar: :any_skip_relocation, mojave:         "389cd2270eededef8623fda47663f998cca159b82f17ef030962ac7dbae3522b"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "-arch", Hardware::CPU.arch, "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/blueutil"
  end

  test do
    system "#{bin}/blueutil"
  end
end

class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://github.com/rharder/imagesnap"
  url "https://github.com/rharder/imagesnap/archive/0.2.14.tar.gz"
  sha256 "6f77ae0200a0d1e342ab6e281a4d5363d8ef97b1b0e4f386d3e927f8dc727475"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cab0cdeac3bb6d67021107d754628c02cb22b1e1111049cf6cac6d4dfdd3859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0b0e448b487416847f57dd541f031b3f35b369d43e0317293f99043ed60b820"
    sha256 cellar: :any_skip_relocation, monterey:       "acd11ffa88be2018f9fdad03371404284fb93d515dba7569b4219b8cb09dc37e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d388402a4c5cbbd2ffe370dcc792075688fa55baedcd093c00f02b262a3ca942"
    sha256 cellar: :any_skip_relocation, catalina:       "29524d3af5547a05136b5cb91a73e596a4aaa64f5a9fb437207814240439a3b8"
    sha256 cellar: :any_skip_relocation, mojave:         "58b490ef6922ecc4fbd89b66275417562ce18fb3b7107804117a75a56b006dc9"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "-project", "ImageSnap.xcodeproj", "SYMROOT=build"
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end

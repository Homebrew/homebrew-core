class Alerter < Formula
  desc "Send User Alert Notification on macOS from the command-line"
  homepage "https://github.com/vjeantet/alerter"
  url "https://github.com/vjeantet/alerter/archive/refs/tags/004.tar.gz"
  sha256 "c4c16735e1a57ce04a5acfa762bd44ab8ef10884308725ab886b984b1de17bfe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bfb9d6b53d55393286a21be46b9581de60f7c2c1b30f487b8eb0762f9210925"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cf062e21dfc3c797838b9f8e7c47888aebb931358501929310756c9b692eb13"
    sha256 cellar: :any_skip_relocation, monterey:       "d7abf3c8dab9fc51147f7ba083115f39b2817a3a79861be861fb293ca0c176a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1fb85ecc81cf1e4e76b25f5847fa44dc76b8406787633a50e9fb612c93a191e"
    sha256 cellar: :any_skip_relocation, catalina:       "1651d372410551bb8d723b1d1bc98ded7bc15b4708be3a849e34929807f5fb81"
    sha256 cellar: :any_skip_relocation, mojave:         "894f1e5649ce05f1413d4bab20b9faf97dc19800698472535907811b930fc498"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
                "-project", "alerter.xcodeproj",
                "-target", "alerter",
                "-configuration", "Release",
                "SYMROOT=build",
                "CODE_SIGN_IDENTITY=",
                "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/alerter"
  end

  test do
    system "alerter", "-timeout", "1", "-title", "Alerter Test", "-message", "test"
  end
end

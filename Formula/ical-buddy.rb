class IcalBuddy < Formula
  desc "Get events and tasks from the macOS calendar database"
  homepage "https://hasseg.org/icalBuddy/"
  url "https://github.com/DavidKaluta/icalBuddy64/releases/download/v1.10.1/icalBuddy-v1.10.1.zip"
  sha256 "720a6a3344ce32c2cab7c3d2b686ad8de8d9744b747ac48b275247ed54cb3945"
  license "MIT"
  head "https://github.com/DavidKaluta/icalBuddy64.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fde583324695c0393cad4e545697c010d2e14dca39281ceff644dee8ed9230ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "41f2928f8a9b5862e9864f5663e6f9cf179e8cfcd95305a41c7c610f7713446d"
    sha256 cellar: :any_skip_relocation, catalina:      "4f621e8b12e2c2e5e7c9fdd97ee973b7d4b14ce58eb5a5f7a9db32243f0f99f1"
    sha256 cellar: :any_skip_relocation, mojave:        "4f621e8b12e2c2e5e7c9fdd97ee973b7d4b14ce58eb5a5f7a9db32243f0f99f1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4f621e8b12e2c2e5e7c9fdd97ee973b7d4b14ce58eb5a5f7a9db32243f0f99f1"
  end

  depends_on :macos

  def install
    args = %W[icalBuddy icalBuddy.1 icalBuddyLocalization.1
              icalBuddyConfig.1 COMPILER=#{ENV.cc}]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end

class IcalBuddy < Formula
  desc "Get events and tasks from the macOS calendar database"
  homepage "https://hasseg.org/icalBuddy/"
  url "https://github.com/dkaluta/icalBuddy64/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "aff42b809044efbf9a1f7df7598e9e110c1c4de0a4c27ddccde5ea325ddc4b77"
  license "MIT"
  revision 1
  head "https://github.com/dkaluta/icalBuddy64.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fde583324695c0393cad4e545697c010d2e14dca39281ceff644dee8ed9230ab"
    sha256 cellar: :any_skip_relocation, monterey:      "90fb3dbedeb785ebca38818ee6ef240680bc3b125382ea33063536b5e5ab2b39"
    sha256 cellar: :any_skip_relocation, big_sur:       "41f2928f8a9b5862e9864f5663e6f9cf179e8cfcd95305a41c7c610f7713446d"
    sha256 cellar: :any_skip_relocation, catalina:      "4f621e8b12e2c2e5e7c9fdd97ee973b7d4b14ce58eb5a5f7a9db32243f0f99f1"
    sha256 cellar: :any_skip_relocation, mojave:        "4f621e8b12e2c2e5e7c9fdd97ee973b7d4b14ce58eb5a5f7a9db32243f0f99f1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4f621e8b12e2c2e5e7c9fdd97ee973b7d4b14ce58eb5a5f7a9db32243f0f99f1"
  end

  depends_on :macos

  def install
    # Allow native builds rather than only x86_64
    inreplace "Makefile", "-arch x86_64", ""

    args = %W[
      icalBuddy
      icalBuddy.1
      icalBuddyLocalization.1
      icalBuddyConfig.1
      COMPILER=#{ENV.cc}
      APP_VERSION=#{version}
    ]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end

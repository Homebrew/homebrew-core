class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.6.0.tar.gz"
  sha256 "ff1fba560743cba7b661e8daef52d4494acc084da4a21c3fad211f7cdf5e971f"
  head "https://github.com/prasmussen/chrome-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcbd7ddb868c433f456921994be98e77d14bad4b51f3b1d5940def7bd845e7f5" => :catalina
    sha256 "45226a0320842d8e3d717ffdf6e8828b9d1b5f52609757670f4d542fd722ee68" => :mojave
    sha256 "b34f789eefdbb6312b05e4e55a71e9deaf889fe740e2d976cdf4279a0d74dd36" => :high_sierra
    sha256 "31abf08f56dc906ec882cb4d7dc167424177c8849b8de8ecb71098afb249fc84" => :sierra
    sha256 "e1d04616371d4c7147f884886d2e61df3bdea48c388dc50a684434f89b417792" => :el_capitan
  end

  depends_on :xcode => :build

  def install
    # Release builds
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/chrome-cli"

    # Canary builds; see:
    # https://github.com/prasmussen/chrome-cli/issues/15
    rm_rf "build"
    inreplace "chrome-cli/App.m", "com.google.Chrome", "com.google.Chrome.canary"
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/chrome-cli" => "chrome-canary-cli"

    # Chromium builds; see:
    # https://github.com/prasmussen/chrome-cli/issues/31
    rm_rf "build"
    inreplace "chrome-cli/App.m", "com.google.Chrome.canary", "org.Chromium.chromium"
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/chrome-cli" => "chromium-cli"
  end

  test do
    system "#{bin}/chrome-cli", "version"
  end
end

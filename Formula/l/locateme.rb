class Locateme < Formula
  desc "Find your location using Apple's geolocation services"
  homepage "https://iharder.sourceforge.net/current/macosx/locateme/"
  url "https://downloads.sourceforge.net/project/iharder/locateme/LocateMe-v0.2.1.zip"
  sha256 "137016e6c1a847bbe756d8ed294b40f1d26c1cb08869940e30282e933e5aeecd"
  license :public_domain

  livecheck do
    url :stable
    regex(%r{url=.*?/LocateMe[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "105cc7bd0d5ced058850ebdd18e3b57d0969f9ef9f185665e28e785194e5cf6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fb9d44f815969d55f09881d36089f4a34a43f7d63ad665a5dec05d8c39c55d59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "078afab4984cf539ac2a9f02d3c13c0756587637293c5b5db7399e835d12092d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee7e0709959839eb57d29307a2f835a93cb69e36eddd389bd62fb2d58d7e95be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c3de0a8398901fcfa93cce0b7dbaeb38989029d1eb2b76cac4246b042b3ef27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f946f1ef48eae5f8cbbdcd78655f3baf0cae307f2730b4aea76360044ed315e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7b44e5cf6385428d8523b2429a53fd2a607be98d663dd5420bb96576320abf2"
    sha256 cellar: :any_skip_relocation, ventura:        "db1688ffa07905231ed8d2c04fe43c2eabd575541ef596e16a67eec803275250"
    sha256 cellar: :any_skip_relocation, monterey:       "df78b2ec950567f3c9889e73c1b0885d6b840569f76cd2a798bdff4c190e337a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4f5de110206a157b8deebb41782e6be482cab8649dfbc5aa6eedae39a7f1374"
    sha256 cellar: :any_skip_relocation, catalina:       "20c927c90ce8813ed161667367c75f8235705fe9fe4c8e5cc6e0b0505b19c978"
  end

  depends_on :macos

  def install
    system ENV.cc, "-framework", "Foundation", "-framework", "CoreLocation", "LocateMe.m", "-o", "LocateMe"
    bin.install "LocateMe"
    man1.install "LocateMe.1"
  end

  test do
    system bin/"LocateMe", "-h"
  end
end

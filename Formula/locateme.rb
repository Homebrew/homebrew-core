class Locateme < Formula
  desc "Find your location using Apple's geolocation services"
  homepage "https://iharder.sourceforge.io/current/macosx/locateme"
  url "https://downloads.sourceforge.net/project/iharder/locateme/LocateMe-v0.2.1.zip"
  sha256 "137016e6c1a847bbe756d8ed294b40f1d26c1cb08869940e30282e933e5aeecd"
  license :public_domain

  livecheck do
    url :stable
    regex(%r{url=.*?/LocateMe[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c3de0a8398901fcfa93cce0b7dbaeb38989029d1eb2b76cac4246b042b3ef27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f946f1ef48eae5f8cbbdcd78655f3baf0cae307f2730b4aea76360044ed315e"
    sha256 cellar: :any_skip_relocation, monterey:       "df78b2ec950567f3c9889e73c1b0885d6b840569f76cd2a798bdff4c190e337a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4f5de110206a157b8deebb41782e6be482cab8649dfbc5aa6eedae39a7f1374"
    sha256 cellar: :any_skip_relocation, catalina:       "20c927c90ce8813ed161667367c75f8235705fe9fe4c8e5cc6e0b0505b19c978"
    sha256 cellar: :any_skip_relocation, mojave:         "3ece081d7d799312e2f1afb6cdc210a5915a89e30143412fa30f2d1953701ede"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e5be4f7b94d001483320c2445739e26deb3007f8fb54185eac4c1cdf941114a3"
    sha256 cellar: :any_skip_relocation, sierra:         "cb5fe0b740f04c036726e546481f0eed603873ce57b063e0621ae8f73f66645d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "5f8e1febc1886565bfa9691cb3ffc0486999f8b682a52276c1d9ea6e0f1f4470"
    sha256 cellar: :any_skip_relocation, yosemite:       "a7876905a4c06452431e506523c5fdf142e2de364427600122fbb9b4928bc6d1"
  end

  depends_on :macos

  def install
    system ENV.cc, "-framework", "Foundation", "-framework", "CoreLocation", "LocateMe.m", "-o", "LocateMe"
    bin.install "LocateMe"
    man1.install "LocateMe.1"
  end

  test do
    system "#{bin}/LocateMe", "-h"
  end
end
